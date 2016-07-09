json.array!(@groups) do |group|
  json.extract! group, :id, :name, :examMark, :schoolAverage, :isRecommended, :isForeign, :speciality, :secondSpeciality, :group, :turn, :finalSpeciality
  json.url request_url(group, format: :json)
end
