class AddUntappdIdToBeers < ActiveRecord::Migration[6.0]
  def change
    add_column :beers, :untappd_id, :integer
  end
end
