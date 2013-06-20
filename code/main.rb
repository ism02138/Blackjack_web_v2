require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

get '/' do			
	session[:show_player_buttons] = true
	session[:show_computer_buttons] = false
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

	erb :play_game
end

post '/player_hit' do
	session[:player_hand] << session[:deck].pop
	if hand_sum(session[:player_hand]).min > 21
		@show_player_buttons = false
		erb :play_game
	else
		redirect '/game_over'
	end
end

post '/player_stay' do
	session[:show_player_buttons] = false
	redirect '/computer'
end

get '/computer' do
	if hand_sum(session[:computer_hand]).min < 17
		session[:show_computer_buttons] = true
		erb :play_game
	else
		redirect '/game_over'
	end
end

post '/computer_hit' do
	session[:computer_hand] << session[:deck].pop
	redirect '/computer'
end

get '/game_over' do
	erb :game_over
end

helpers do
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
		end	
		return sum
	end

	def return_card_picture(card)
		return "<img src='/images/cards/#{card[0]}_#{card[1]}.jpg' class='card_image'>"
	end

	def compare_hands(hand1, hand2)
		player_hand = hand_sum(hand1)
		computer_hand = hand_sum(hand2)

		if player_hand.min > 21
			return "Player was over 21 with #{player_hand.min}"
		elsif computer_hand.min > 21
			return "Computer was over 21 with #{computer_hand.min}"
		else
			player_best = player_hand.select { |total| total < 22 }.max
			computer_best = computer_hand.select { |total| total < 22 }.max
			if player_best > computer_best
				return "Player wins with #{player_best}. Computer had #{computer_best}"
			else
				return "Computer wins with #{computer_best}. Player had #{player_best}"
			end
		end
	end
end
