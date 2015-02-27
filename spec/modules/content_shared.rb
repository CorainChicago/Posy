require 'rails_helper'

# This file is loaded in ../support/loading.rb so that
# it can be referenced in multiple other files.

RSpec.shared_examples "Content" do
  let(:content) { create(described_class) }
  let(:flagged_content) { create(described_class, status: -1) }

  describe '#clear?' do
    it 'returns true if the content is publishable' do
      expect(content.clear?).to be_truthy
    end

    it 'returns false if the content is hidden' do
      expect(flagged_content.clear?).to be_falsey
    end
  end

  describe '#mark_as_cleared' do
    it 'changes the content\'s status to 1' do
      expect{ flagged_content.mark_as_cleared }.to \
        change(flagged_content, :status).to(1)
    end
  end

  describe '#mark_as_removed' do
    it 'changes the content\'s status to -2' do
      expect{ content.mark_as_removed }.to \
        change(content, :status).to(-2)
    end
  end

  describe '#update_flagged_count' do
    it 'updates the number of flaggings content has received' do
      flag = Proc.new { create(:flagging, flaggable: content) }

      expect{ flag.call }.to change(content, :flagged).by(1)
    end

    it 'hides the content if above flagging threshold' do
      flag = Proc.new { create(:flagging, flaggable: content, session_id: Flagging.count.to_s) }
      threshold = 2   # Can this be decoupled? Must be changed manually.
      (threshold - 1).times { flag.call }

      expect{ flag.call }.to change(content, :status).to(-1)
    end
  end

  describe '#admin_priority?' do
    it 'returns true if status is -1' do
      expect(flagged_content.admin_priority?).to be_truthy
    end

    it 'returns false if status is not -1' do
      expect(content.admin_priority?).to be_falsey
    end
  end

end