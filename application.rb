require 'sinatra'
require 'redis'
require './family'

get '/' do
  redis = Family.redis_client
  haml :index, locals: {family_members: redis.hgetall('assignments'), generated_at: redis.get('generated_at')}
end
