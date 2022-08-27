# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'dotenv/load'

require 'mail'
require 'nokogiri'
require 'open-uri'

threshold = (ENV['THRESHOLD'] || 17).to_i
draw_days = (ENV['DRAW_DAYS'] || 'mardi,vendredi').split(',')
today = {
  1 => 'lundi',
  2 => 'mardi',
  3 => 'mercredi',
  4 => 'jeudi',
  5 => 'vendredi',
  6 => 'samedi',
  7 => 'dimanche'
}[Time.now.wday]

print 'Is today a desired draw day? '
if draw_days.include? today
  puts "✓ (#{today})"
else
  puts "✕ (#{today})"
  return
end

base_url = 'https://www.fdj.fr/jeux-de-tirage/euromillions-my-million/resultats'
response = URI.parse(base_url).read
html = Nokogiri::HTML(response)

amount = html.css('.result-full__announce-gainNum').text.strip.to_i

print "Has the jackpot reached #{threshold}M€? "
if amount >= threshold
  puts "✓ (#{amount}M€)"
else
  puts "✕ (#{amount}M€)"
  return
end

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
  subject "Euromillion: #{amount}M€ ce #{today}"
end

mail.deliver!

puts '✓'
