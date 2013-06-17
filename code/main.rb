require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

get '/' do			
	session[:computer_name] = "Evil Computer"
	if session[:player_name]
		redirect '/play_game'
	else
		redirect '/new_player'
	end
end

get '/new_player' do 
	erb :new_player
end

post '/new_player' do 
	session[:player_name] = params[:player_name]
	redirect '/play_game'
end

get '/play_game' do
	suits = ['H', 'D', 'S', 'C']
	values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
	session[:deck] = suits.product(values).shuffle!

	session[:player_hand] = []
	session[:computer_hand] = []

	session[:player_hand] << session[:deck].pop
	session[:computer_hand] << session[:deck].pop
	session[:player_hand] << session[:deck].pop
	session[:computer_hand] << session[:deck].pop

	erb :play_game
end