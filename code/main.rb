require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true


get '/' do				# router action
	"Hello World!!"	# controller
end

get '/hello' do
	@name = 'ian'
	erb :test
end

get '/redirect' do
	redirect '/hello'
end

post '/my_form' do
	puts params['username']
end
