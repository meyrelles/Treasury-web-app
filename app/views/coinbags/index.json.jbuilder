#json.array! @coinbags, partial: 'coinbags/coinbag', as: :coinbag
json.array!(@coinbags) do |coinbag|
  json.extract! coinbag, :id, :coinbag
  json.url coinbag_url(coinbag, format: :json)
end
