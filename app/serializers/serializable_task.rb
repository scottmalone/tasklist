class SerializableTask < JSONAPI::Serializable::Resource
  type :tasks

  has_many :attachments

  attribute :id
  attribute :user_id
  attribute :description
  attribute :due
  attribute :completed
  attribute :position
end
