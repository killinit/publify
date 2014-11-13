RSpec.describe FlagsController, type: :controller do
  let!(:blog) { create(:blog) }
  let(:comment) { create(:comment) }
  let(:comment_id) { comment.id }
  let(:explanation) { 'my great explanation' }
  let(:flag) do {
    explanation: explanation
  } end

  before do
    post :create, id: comment_id, flag: flag
  end

  context 'when the comment does not exist' do
    let(:comment_id) { 123 }

    specify { expect(response).to be_not_found }
    specify { expect(comment.flags.count).to eq(0) }
  end

  context 'when the comment does exist' do
    context 'and the params are invalid' do
      let(:explanation) { '' }

      specify { expect(response.code).to eq('400') }
      specify { expect(comment.flags.count).to eq(0) }
    end

    context 'and the params are valid' do
      specify { expect(response.code).to eq('201') }
      specify { expect(comment.flags.count).to eq(1) }
      specify { expect(comment.flags.first.explanation).to eq(explanation) }
    end
  end
end
