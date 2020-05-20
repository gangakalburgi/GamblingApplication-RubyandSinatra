require 'dm-core'
require 'dm-migrations'
#require 'sinatra'


#DataMapper.setup(:default,  "sqlite3://#{Dir.pwd}/gamble.db")


class Gamble
  include DataMapper::Resource
  property :id,Serial, :key =>false
  property :username,Text, :key =>true
  property :password, Text 
  property :won,Integer
  property :lost,Integer
  property :profit,Integer

end


DataMapper.finalize 