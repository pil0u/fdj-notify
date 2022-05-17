# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'dotenv/load'

require 'byebug'
require 'mail'
require 'nokogiri'
require 'open-uri'

threshold = (ENV['THRESHOLD'] || 17).to_i
draw_days = (ENV['DRAW_DAYS'] || 'mardi,vendredi')

base_url = 'https://www.fdj.fr/jeux-de-tirage/euromillions-my-million'
response = URI.parse(base_url).read
html = Nokogiri::HTML(response)

amount = html.css('.banner-euromillions_text-gain_num > text()').text.strip.to_i

# TODO: unreliable when the draw is ongoing (we get "Tous les mardis et vendredis")
next_draw = html.css('.banner-euromillions_text-date').text.strip
next_draw_day = next_draw.split[0]

return unless amount >= threshold && draw_days.split(',').include?(next_draw_day)

options = {
  address: 'smtp.gmail.com',
  port: 587,
  user_name: ENV['MAILER_USER_NAME'],
  password: ENV['MAILER_PASSWORD'],
  authentication: 'plain',
  enable_starttls_auto: true
}

Mail.defaults do
  delivery_method :smtp, options
end

mail = Mail.new do
  from    ENV['MAILER_USER_NAME']
  to      ENV['MAILER_USER_NAME']
  subject "Euromillion: #{amount}M€ ce #{next_draw_day}"
end

mail.deliver!
