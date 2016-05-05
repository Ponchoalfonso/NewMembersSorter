json.array!(@requests) do |request|
  json.extract! request, :id, :name, :examMark, :schoolAverage, :isRecommended, :isForeign, :speciality, :secondSpeciality
  json.url request_url(request, format: :json)
end
