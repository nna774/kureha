require "rb-inotify"
require 'base64'
require 'net/http'

WATCHPATH = "images/"

HOST = 'gyazo.com'
PATH = '/upload.cgi'
UA   = 'Kureha Tsubaki/Yuri 0.1.0'

def upload(imagename)
  idfile = ".gyazo.id"
  id = ''
  if File.exist?(idfile) then
    id = File.read(idfile).chomp
  end
  imagedata = File.read(WATCHPATH + imagename)
  boundary = '----BOUNDARYBOUNDARY----'

  data = <<EOF
--#{boundary}\r
content-dispositionp: form-data; name="id"\r
\r
#{id}\r
--#{boundary}\r
content-disposition: form-data; name="imagedata"; filename="gyazo.com"\r
\r
#{imagedata}\r
--#{boundary}--\r
EOF

  header ={
    'Content-Length' => data.length.to_s,
    'Content-type' => "multipart/form-data; boundary=#{boundary}",
    'User-Agent' => UA
  }
  env = ENV['http_proxy']
  if env then
    uri = URI(env)
    proxy_host, proxy_port = uri.host, uri.port
  else
    proxy_host, proxy_port = nil, nil
  end
  Net::HTTP::Proxy(proxy_host, proxy_port).start(HOST,80) do |http|
    res = http.post(PATH,data,header)
    url = res.response.body
    puts url
    newid = res.response['X-Gyazo-Id']
    if newid and newid != "" then
      if !File.exist?(File.dirname(idfile)) then
        Dir.mkdir(File.dirname(idfile))
      end
      if File.exist?(idfile) then
        File.rename(idfile, idfile+Time.new.strftime("_%Y%m%d%H%M%S.bak"))
      end
      File.open(idfile,"w").print(newid)
    end
  end
end

notifier = INotify::Notifier.new

notifier.watch(WATCHPATH, :moved_to) do |event|
  imagename = event.name
  puts "#{imagename} upload."
  upload(imagename)
end

notifier.run
