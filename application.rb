require 'sinatra'
require 'redis'

get '/' do
  redis = Redis.new
  haml :index, locals: {family_members: redis.hgetall('assignments'), generated_at: redis.get('generated_at')}
end
