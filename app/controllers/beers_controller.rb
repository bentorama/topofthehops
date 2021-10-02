class BeersController < ApplicationController
  require 'open-uri'
  require 'json'
  require_relative 'breweries_controller'

  def index
    if params["search"]["beer_1"].present? && params["search"]["beer_1"] != ""
      @beers = []
      @ratings = []
      params["search"].each_value do |value|
        result = Beer.global_search(value).first
        result ? @beers << result : call_untappd(value)
      end
    else
      @beer = "Nothing searched"
    end
  end

  private

  def call_untappd(search)
    untappd_id = ENV['UNTAPPD_ID']
    untappd_secret = ENV['CLIENT_SECRET']
    url = "https://api.untappd.com/v4/search/beer?q=#{search}&client_id=#{untappd_id}&client_secret=#{untappd_secret}"
    beer_serialized = URI.parse(url).open.read
    result = JSON.parse(beer_serialized)["response"]["beers"]["items"].first
    brewery = brewery_in_db(result)
    rating = get_rating(result)
    beer = add_beer(result["beer"], rating, brewery)
    @beers << beer
  end

  def get_rating(beer)
    untappd_id = ENV['UNTAPPD_ID']
    untappd_secret = ENV['CLIENT_SECRET']
    bid = beer["beer"]["bid"]
    url = "https://api.untappd.com/v4/beer/info/#{bid}?&client_id=#{untappd_id}&client_secret=#{untappd_secret}"
    beer_serialized = URI.parse(url).open.read
    JSON.parse(beer_serialized)["response"]["beer"]["rating_score"]
  end

  def brewery_in_db(beer)
    untappd_id = beer["brewery"]["brewery_id"]
    result = Brewery.search_by_untappd_id(untappd_id).first
    result ||= add_brewery(beer["brewery"])
    result
  end

  def add_brewery(brewery)
    new_brewery = Brewery.new
    new_brewery.name = brewery["brewery_name"]
    new_brewery.untappd_id = brewery["brewery_id"]
    new_brewery.city = brewery["location"]["brewery_city"]
    new_brewery.country = brewery["country_name"]
    new_brewery.save!
    new_brewery
  end

  def add_beer(beer, rating, brewery)
    new_beer = Beer.new
    new_beer.name = beer["beer_name"]
    new_beer.style = beer["beer_style"]
    new_beer.description = beer["beer_description"]
    new_beer.untappd_rating = rating
    new_beer.untappd_id = beer["bid"]
    new_beer.brewery = brewery
    new_beer.save!
    new_beer
  end
end
