class AddUntappdRatingToBeers < ActiveRecord::Migration[6.0]
  def change
    add_column :beers, :untappd_rating, :float
  end
end
