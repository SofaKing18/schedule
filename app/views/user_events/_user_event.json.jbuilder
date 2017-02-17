json.extract! user_event, :id, :name, :user_id, :start_date, :created_at, :updated_at
json.url user_event_url(user_event, format: :json)