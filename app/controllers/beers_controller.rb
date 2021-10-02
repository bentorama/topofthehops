class BeersController < ApplicationController
  require 'open-uri'
  require 'json'

  def index
    if params["search"]["beer_1"].present? && params["search"]["beer_1"] != ""
      @beers = []
      @ratings = []
      params["search"].each_value do |value|
        result = Beer.global_search(value).first
        if result
          @beers << result
        else
          call_untappd(value)
        end
      end
      call_ratings
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
  end

  def call_ratings
    untappd_id = ENV['UNTAPPD_ID']
    untappd_secret = ENV['CLIENT_SECRET']
    @beers.each do |beer|
      bid = beer["beer"]["bid"]
      url = "https://api.untappd.com/v4/beer/info/#{bid}?&client_id=#{untappd_id}&client_secret=#{untappd_secret}"
      beer_serialized = URI.parse(url).open.read
      @ratings << JSON.parse(beer_serialized)["response"]["beer"]["rating_score"]
    end
  end

  def brewery_in_db(beer)
    untappd_id = beer["brewery"]["brewery_id"]
    result = Brewery.search_by_untappd_id(untappd_id)
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
end
