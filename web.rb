require 'sinatra'

def get_or_post(path, opts={}, &block)
    get(path, opts, &block)
      post(path, opts, &block)
end

get_or_post '/' do
  content_type 'text/plain', :charset => 'utf-8'
  "Hello, world!"
end
