class SerializableTask < JSONAPI::Serializable::Resource
  type :tasks

  attribute :description
  attribute :due
  attribute :completed
  attribute :position
end
