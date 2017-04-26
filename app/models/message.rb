class Message < ActiveRecord::Base
  def post_msg
    room_id = Settings.room.private
    token = ENV["CW_TOKEN"]
    raw_content = "TO ALL >>>"
    raw_content += "[info][title]New Confession (inlove)                                                   ※ Added at: #{created_at}[/title]"
    raw_content += content
    raw_content += news
    raw_content += "[/info]"
    msg_content = URI.encode(raw_content)
    uri = "https://api.chatwork.com/v2/rooms/#{room_id}/messages?body=#{msg_content}"
    url = URI.parse(uri)
    https = Net::HTTP.new(url.host,url.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri, {"X-ChatWorkToken" => token})
    https.request(req)
  end

  private
  def news
    news= "[hr]"
    Advertisement.published.each do |msg|
      news+= "■ "
      news+= msg.content + "\n"
    end
    news
  end
end
