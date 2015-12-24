json.array!(@emps) do |emp|
  json.extract! emp, :id, :name, :job, :age
  json.url emp_url(emp, format: :json)
end
