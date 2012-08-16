require 'sinatra'
require 'yaml'
require 'json'

def get_or_post(path, opts={}, &block)
  get(path, opts, &block)
  post(path, opts, &block)
end

def translate(string, dict)
  dict.each_pair {|key, value|
    string.gsub! key, value
  }
  string
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
    orig = e['message']['text'].dup
    msg = translate(e['message']['text'], dict['hitachi'].merge(dict['reinspired']))
    lines << msg if msg != orig
  }

  ret = lines.join "\n"
end

