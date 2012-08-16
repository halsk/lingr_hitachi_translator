require 'sinatra'
require 'yaml'
require 'json'

def get_or_post(path, opts={}, &block)
    get(path, opts, &block)
      post(path, opts, &block)
end

get_or_post '/' do
  content_type 'text/plain', :charset => 'utf-8'
  dict = YAML::load( File.open( 'dict.yaml' ) )
  dict['hitachi'].default = ''
  dict['reinspire'].default = ''
  begin
    json = JSON.parse(request.body.string)
  rescue
    json = JSON.parse( File.read( 'test.json' ) )
  end
  ret = ''
  json["events"].map{ |e|
    ret += dict['hitachi'][e["message"]["text"]] + "\n" if dict['hitachi'][e["message"]["text"]] != ''
    ret += dict['reinspire'][e["message"]["text"]] + "\n" if dict['reinspire'][e["message"]["text"]] != ''
  }
  ret
end
