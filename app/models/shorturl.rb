class Shorturl < ActiveRecord::Base
  attr_accessible :abbrev, :url

  def self.create_with_url(url)
    while true
      abbrev = generate_abbrev
      if self.find_by_abbrev(abbrev).nil?
        shorturl = self.create({abbrev: abbrev, url: url})
        return shorturl 
      end
    end
  end

  private
    
    def self.generate_abbrev
      SecureRandom.hex(3)
    end
end
