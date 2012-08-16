require 'sinatra'

get '/' do
  content_type 'text/plain', :charset => 'utf-8'
  "Hello, world!"
end
