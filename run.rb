# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'dotenv/load'

require 'mail'
require 'nokogiri'
require 'open-uri'

threshold = (ENV['THRESHOLD'] || 17).to_i
draw_days = (ENV['DRAW_DAYS'] || 'mardi,vendredi')

# Stop the script if today is not a desired draw day
return unless draw_days.split(',').include?({ 2 => 'mardi', 5 => 'vendredi' }[Time.now.wday])

base_url = 'https://www.fdj.fr/jeux-de-tirage/euromillions-my-million/resultats'
response = URI.parse(base_url).read
html = Nokogiri::HTML(response)

amount = html.css('.result-full__announce-gainNum').text.strip.to_i
next_draw_day = html.css('.result-full__announce-date').text.downcase.split.first

puts "#{amount}M€ (vs #{threshold}M€)"
puts "#{next_draw_day} (vs #{draw_days})"

return unless amount >= threshold

print "Sending email to #{ENV['MAILER_USER_NAME']}... "

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

puts '✓'
