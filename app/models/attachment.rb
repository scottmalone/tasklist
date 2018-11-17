class Attachment
  attr_reader :id
  attr_reader :filename

  def initialize(active_storage_attachment)
    @id = active_storage_attachment.id
    @filename = active_storage_attachment.filename
  end
end
