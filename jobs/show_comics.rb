require 'rest_client'
require_relative 'get_comics.rb'

SCHEDULER.every '5s', :first_in => '10s' do |job|
  send_event('twc_issue_big_picture', image: $weekly_comics_results[0]['images'].first['path'] + '.jpg')
  send_event('twc_issue_title', title: $weekly_comics_results[0]['title'])
  send_event('twc_issue_description', text: $weekly_comics_results[0]['description'])
  send_event('twc_preview_thumbnail_1', image: $weekly_comics_results[1]['thumbnail'].first.last + '.jpg')
  send_event('twc_preview_thumbnail_2', image: $weekly_comics_results[2]['thumbnail'].first.last + '.jpg')
  send_event('twc_preview_thumbnail_3', image: $weekly_comics_results[3]['thumbnail'].first.last + '.jpg')
  send_event('twc_preview_thumbnail_4', image: $weekly_comics_results[4]['thumbnail'].first.last + '.jpg')

  $weekly_comics_results.rotate!
end

SCHEDULER.every '20s', :first_in => '10s' do |job|
  creators_string = ""

  $amazing_spider_man_results[0]["creators"]["items"].each do |item|
    creators_string += item["name"] + " " + item["role"]
    if item == $amazing_spider_man_results[0]["creators"]["items"].last
      creators_string += "."
    else
      creators_string += ", "
    end
  end

  sale_date = DateTime.parse($amazing_spider_man_results[0]["dates"][0]["date"]).to_date
  formatted_sale_date = sale_date.strftime("%B %d, %Y")

  send_event('asm_issue_big_picture', image: $amazing_spider_man_results[0]['images'].first['path'] + '.jpg')
  send_event('asm_issue_title', text: $amazing_spider_man_results[0]['title'])
  send_event('asm_issue_description', text: $amazing_spider_man_results[0]["description"].to_s)
  send_event('asm_creators', text: creators_string)
  send_event('asm_sale_date', text: formatted_sale_date)
  send_event('asm_sale_price', text: "$" + $amazing_spider_man_results[0]["prices"][0]["price"].to_s)

  $amazing_spider_man_results.rotate!
end
