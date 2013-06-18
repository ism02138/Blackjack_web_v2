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
	suits = ['hearts', 'diamonds', 'clubs', 'spades']
	values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'jack', 'queen', 'king', 'ace']
	session[:deck] = suits.product(values).shuffle!

	session[:player_hand] = []
	session[:computer_hand] = []

	session[:player_hand] << session[:deck].pop
	session[:computer_hand] << session[:deck].pop
	session[:player_hand] << session[:deck].pop
	session[:computer_hand] << session[:deck].pop

	session[:player_total] = hand_sum(session[:player_hand])
	session[:computer_total] = hand_sum(session[:computer_hand])

	erb :play_game
end

def hand_sum(hand)
	sum = [0, 0]
	hand.each { |suit, value|
		if value == 'jack' || value == 'queen' || value == 'king'
			sum[0] += 10
			sum[1] += 10
		elsif value == 'ace'
			sum[0] += 1
			sum[1] += 11
		else
			sum[0] += value.to_i
			sum[1] += value.to_i
		end
	}
	if sum[1] > 21 || sum[0] == sum[1]
		sum.pop
		return "#{sum[0]}"
	end	
	return "#{sum[0]} or #{sum[1]}"
end