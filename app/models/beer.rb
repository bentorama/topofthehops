class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :favourites, dependent: :destroy
end
