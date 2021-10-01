class BeersController < ApplicationController
  require 'open-uri'
  require 'json'

  def index
    if params[:query].present? && params[:query] != ""
      call_untappd(params[:query])
    end
  end

  private

  def call_untappd(search)
    untappd_id = ENV['UNTAPPD_ID']
    untappd_secret = ENV['CLIENT_SECRET']
    url = "https://api.untappd.com/v4/search/beer?q=#{search}&client_id=#{untappd_id}&client_secret=#{untappd_secret}"
    beer_serialized = URI.open(url).read
    @beer = JSON.parse(beer_serialized)
  end
end
