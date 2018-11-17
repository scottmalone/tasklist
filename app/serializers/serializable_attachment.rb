class SerializableAttachment < JSONAPI::Serializable::Resource
  type :attachments

  attribute :id
  attribute :filename
end
