json.array!(@institute_users) do |institute_user|
  json.extract! institute_user, :id
  json.url institute_user_url(institute_user, format: :json)
end
