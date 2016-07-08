class Request < ActiveRecord::Base

  def self.import(file)
    CSV.foreach(file.path, headers: true, :encoding => 'ISO-8859-1') do |row|
      Request.create! row.to_hash
    end
  end

end
