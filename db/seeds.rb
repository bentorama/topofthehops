# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'rtesseract'
require 'rmagick'
include Magick

menu = '/home/bentorama/code/bentorama/topofthehops/app/assets/images/example_01.png'

test = ImageList.new(menu)
test.display

# image = RTesseract.new(menu).to_box
# # image.to_s.each_line { |s| puts s }
# p image