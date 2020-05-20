#require 'data_mapper'
require 'sinatra'
require './person'


#DataMapper.setup(:default,  "sqlite3://#{Dir.pwd}/gamble.db")
# class Gamble
# 	include DataMapper::Resource
# 	property :id,Serial, :key =>false
# 	property :username,Text, :key =>true


configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/gamble.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end


configure do
  enable :sessions     # set :sessions, true
  #values present in db
  #@user = Gamble.get(params[:username])
  #set :username, "ganga"
  #set :password, "ganga123"
end


get '/' do 
	erb :home
end

get '/home' do 
	erb :home
end

get '/login' do 
  if session[:login]
    erb :visit
  else
    erb :login
  end
end

post '/login' do	

     @user = Gamble.get(params[:username])
    #puts "user : #{@user}" 

    #getting values in session#
    session[:username] = @user.username
    session[:totalwin] = @user.won
    session[:totalloss] = @user.lost
    session[:totalprofit] = @user.profit
  
    


  #if params[:username] == settings.username && params[:password] == settings.password
  

  if params[:username] == @user.username && params[:password] == @user.password
 	  session[:login] = true
 	  session[:login] = true
    session[:name] = params[:username]
    erb :visit
  else
    session[:message] = "username and password does not match"
    redirect '/login'
  end
end



get '/bet' do
	erb :visit
end



post '/bet' do

	  @user = Gamble.get(params[:username])

	  stake = params[:betmoney].to_i
   	number = params[:number].to_i
  	roll = rand(6) + 1

 	 if number == roll
      session[:currentwin] = 10 * stake 
      session[:currentloss] = 0
      session[:message] = "The dice landed on #{roll}, you win #{10*stake} dollars"
      @profit = session[:currentwin].to_i - session[:currentloss].to_i  
      save_session(:currentprofit,@profit)
      erb :visit
  	else
      session[:currentloss] = stake
      session[:currentwin] = 0;
      session[:message] = "The dice landed on #{roll},you lost"
      @profit = session[:currentwin].to_i - session[:currentloss].to_i  
      save_session(:currentprofit,@profit)
      erb :visit
  	end

end


def save_session(won_lost, money)
  count = (session[won_lost] || 0).to_i
  count += money
  session[won_lost] = count
end



get '/logout' do

  @user = Gamble.get(session[:username])
  puts "user : #{@user}"


  currentwon = session[:currentwin].to_i
  currentwon += @user.won
  @user.won = currentwon
  @user.save

  currentloss = session[:currentloss].to_i
  currentloss += @user.lost
  @user.lost = currentloss
  @user.save


  currentprofit = session[:currentprofit].to_i
  currentprofit += @user.profit
  @user.profit = currentprofit
  @user.save


  session[:login] = nil
  session[:name] = nil
  session[:currentwin] = nil
  session[:currentloss] = nil
  session[:currentprofit] = nil
  redirect '/home'
end


