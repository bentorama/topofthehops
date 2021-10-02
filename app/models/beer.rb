class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :favourites, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :global_search,
                  against: %i[name description],
                  associated_against: {
                    brewery: [:name]
                  },
                  using: {
                    tsearch: { prefix: true }
                  }
end
