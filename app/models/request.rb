class Request < ActiveRecord::Base

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Request.create! row.to_hash
    end
  end
  


end
