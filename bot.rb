require 'telegram/bot'
require_relative 'utils'
require_relative 'variables'

puts "Bot started at #{Time.now}"
puts "▶ A simple project made using Ruby Language by 🄺🄰🅁🄼🄰"
puts "▶ Join @ProjectCodeX"

Telegram::Bot::Client.run(Variables::TOKEN) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}! I am SonicBot, developed using Ruby")
    when '/bye'
      bot.api.send_message(chat_id: message.chat.id, text: "Goodbye, #{message.from.first_name}!")
    when '/ping'
      start_time = Time.now
      response = bot.api.send_message(chat_id: message.chat.id, text: 'Pong!')
      end_time = Time.now
      duration = (end_time - start_time).round(2)

      bot.api.send_message(chat_id: message.chat.id, text: "Ping: #{duration} seconds")
    when '/joke'
      joke = get_single_joke(Variables::JOKE_API_ENDPOINT)
      bot.api.send_message(chat_id: message.chat.id, text: joke)
    end
  end
end
