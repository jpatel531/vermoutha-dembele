require 'sinatra'

get '/' do 
  'hello'
end

post '/images' do
  puts params.inspect
end