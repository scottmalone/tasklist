json.extract! task, :id, :user_id, :position, :completed, :due, :description, :created_at, :updated_at
json.url task_url(task, format: :json)
