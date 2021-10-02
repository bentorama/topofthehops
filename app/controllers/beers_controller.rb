class BeersController < ApplicationController
  require 'open-uri'
  require 'json'

  def index
    if params["search"]["beer_1"].present? && params["search"]["beer_1"] != ""
      @beers = []
      @ratings = []
      params["search"].each_value do |value|
        call_untappd(value)
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
    beer_serialized = URI.open(url).read
    @beers << JSON.parse(beer_serialized)["response"]["beers"]["items"].first
  end

  def call_ratings
    untappd_id = ENV['UNTAPPD_ID']
    untappd_secret = ENV['CLIENT_SECRET']
    @beers.each do |beer|
      bid = beer["beer"]["bid"]
      url = "https://api.untappd.com/v4/beer/info/#{bid}?&client_id=#{untappd_id}&client_secret=#{untappd_secret}"
      beer_serialized = URI.open(url).read
      @ratings << JSON.parse(beer_serialized)["response"]["beer"]["rating_score"]
    end
  end
end
