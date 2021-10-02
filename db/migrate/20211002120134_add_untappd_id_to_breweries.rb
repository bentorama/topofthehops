class AddUntappdIdToBreweries < ActiveRecord::Migration[6.0]
  def change
    add_column :breweries, :untappd_id, :integer
  end
end
