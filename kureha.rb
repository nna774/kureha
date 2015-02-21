require "rb-inotify"

require_relative "config"

WATCHPATH = "images/"

def upload(imagename)
  cmd = "curl -X POST https://upload.gyazo.com/api/upload -F \"access_token=#{ACCESS_TOKEN}\"  -F \"imagedata=@#{imagename}\" > /dev/null"
  puts `#{cmd}`
end

notifier = INotify::Notifier.new

notifier.watch(WATCHPATH, :moved_to) do |event|
  imagename = event.name
  puts "#{imagename} upload."
  upload(WATCHPATH + imagename)
end

notifier.run
