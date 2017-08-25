RSpec.describe Services::TaskTwitter do
  let(:task) { Fabricate.create(:task, user_id: Fabricate.create(:user).id) }

  subject { Services::TaskTwitter.new.call(task) }

  describe '#call' do
    context 'with correct text' do
      let(:task) { Fabricate.create(:task, user_id: Fabricate.create(:user).id) }

      it 'sends tweet' do
        VCR.use_cassette("task_twitter_sender") do
          expected_text = "#{task.title} #ossboard https://is.gd/DHouda"
          expect(subject).to eq expected_text
        end
      end
    end

    context 'when title long' do
      let(:task) { Fabricate.create(:task, title: Faker::Lorem.paragraph, user_id: Fabricate.create(:user).id) }

      it { VCR.use_cassette("task_twitter_sender") { expect(subject.size).to be <= 140 } }
    end
  end
end
