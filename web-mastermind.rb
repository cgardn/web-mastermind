require 'sinatra'
require 'sinatra/reloader'
require './mastermind-core.rb'

enable :sessions

def inputTurn(guess)
  turnresult = game_board.check_move(guess, turn)
  turn += 1
  if turnresult == 'win'
  end
end

get '/' do
  erb :index, :layout => :layout_core
end

get '/game' do
  out = session.to_s

  if session[:game].gamestate == "ingame"
    erb :game, :layout => :layout_core, :locals => {:board => session[:game].display_board_web}
  elsif session[:game].gamestate == "win"
    erb :win, :layout => :layout_core, :locals => {:hiddencode => session[:game].hidden_code}
  elsif session[:game].gamestate == "lose"
    erb :lose, :layout => :layout_core, :locals => {:hiddencode => session[:game].hidden_code}
  else
    erb :index, :layout => :layout_core
  end

end

post '/game' do
  if (params.has_key? :newgame) && params[:newgame] == "true"
    session[:newgame] = true
  end

  if (session.has_key? :newgame) && session[:newgame] == true
    p "has key newgame"
    session[:game] = Board.new
    session[:turn] = 0
    session[:newgame] = false
  end

  if (params.has_key? :guess)
    p "has key guess"
    p params
    p session
    session[:game].check_move(params[:guess], session[:turn])
    session[:turn] += 1
  end
  
  redirect('/game')
end
