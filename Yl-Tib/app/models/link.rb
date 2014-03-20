class Link < ActiveRecord::Base

  validates :original_link, length: { minimum: 5 }

end
