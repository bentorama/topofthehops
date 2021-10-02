class Brewery < ApplicationRecord
  has_many :beers, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :search_by_untappd_id,
                  against: :untappd_id,
                  using: {
                    tsearch: {prefix: false}
                  }

end
