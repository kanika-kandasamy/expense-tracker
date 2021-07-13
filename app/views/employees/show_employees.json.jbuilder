json.(@employees) do |employee|
    json.id employee.id
    json.name employee.name
end