require 'sinatra'
require 'yaml'
require 'json'

def get_or_post(path, opts={}, &block)
  get(path, opts, &block)
  post(path, opts, &block)
end

get_or_post '/' do
  content_type 'text/plain', :charset => 'utf-8'

  dict = YAML::load File.open('dict.yaml')
  dict['hitachi'].default = ''
  dict['reinspired'].default = ''

  begin
    json = JSON.parse request.body.string
  rescue
    json = JSON.parse File.read('test.json')
  end

  lines = []
  json['events'].map{ |e|
    msg = dict['hitachi'][e['message']['text']]
    rmsg = dict['reinspired'][e['message']['text']]
    lines << msg unless msg.empty?
    lines << rmsg unless rmsg.empty?
  }

  ret = lines.join "\n"
end

