json.extract! attachment, :id, :task_id, :name, :location, :created_at, :updated_at
json.url attachment_url(attachment, format: :json)
