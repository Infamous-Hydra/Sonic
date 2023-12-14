require 'httparty'
require_relative 'variables'

module InstadlHandler
  def self.handle_instadl(bot, message)
    command_params = message.text.split(' ')

    if command_params.length < 2
      bot.api.send_message(chat_id: message.chat.id, text: 'Usage: /instadl [Instagram URL]')
      return
    end

    link = command_params[1]

    begin
      downloading_sticker = bot.api.send_sticker(chat_id: message.chat.id, sticker: DOWNLOADING_STICKER_ID)

      # Make a GET request to the API using httparty
      response = HTTParty.get("#{API_URL}?url=#{link}")
      data = response.parsed_response

      # Check if the API request was successful
      if data.key?('content_url')
        content_url = data['content_url']

        # Determine content type from the URL
        content_type = content_url.include?('video') ? 'video' : 'photo'

        # Reply with either photo or video
        if content_type == 'photo'
          bot.api.send_photo(chat_id: message.chat.id, photo: content_url)
        elsif content_type == 'video'
          bot.api.send_video(chat_id: message.chat.id, video: content_url)
        else
          bot.api.send_message(chat_id: message.chat.id, text: 'Unsupported content type.')
        end
      else
        bot.api.send_message(chat_id: message.chat.id, text: 'Unable to fetch content. Please check the Instagram URL.')
      end

    rescue StandardError => e
      puts e
      bot.api.send_message(chat_id: message.chat.id, text: 'An error occurred while processing the request.')

    ensure
      bot.api.delete_message(chat_id: message.chat.id, message_id: downloading_sticker['result']['message_id']) if downloading_sticker
    end
  end
end
