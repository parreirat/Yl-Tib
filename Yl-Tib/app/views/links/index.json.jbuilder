json.array!(@links) do |link|
  json.extract! link, :id, :original_link, :shortened_link, :click_count
  json.url link_url(link, format: :json)
end
