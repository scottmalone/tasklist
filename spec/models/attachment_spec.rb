require 'rails_helper'

RSpec.describe Attachment, type: :model do
  let(:task) { create(:task, :with_attachment) }
  let(:active_storage_attachment) { task.attachments.first }
  let(:attachment) { Attachment.new(active_storage_attachment) }

  it "builds a new instance with id and filename" do
    expect(attachment.id).to eq(active_storage_attachment.id)
    expect(attachment.filename).to eq(active_storage_attachment.filename)
  end
end
