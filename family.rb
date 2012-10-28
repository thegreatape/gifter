require 'redis'
require 'uri'
require 'stamp'

class Family
  def self.members
    [ ['Mattie',
       'Kriddie',
       'Katherine',
       'Scriba'],

      ['Claire',
       'Josh',
       'Samuel',
       'Jordan',
       'Sarabeth',
       'Carol',
       'Frank'],

       ['John',
        'Sharon',
        'Thomas',
        'Elizabeth',
        'Mollie'],

        ['Linda'] ]
  end

  def self.randomize!
    assignments = {}

    members.each do |group|
      group.each do |person|
        recipients = members.flatten - group - assignments.values
        assignments[person] = recipients.delete_at(rand * recipients.length)
      end
    end

    puts "storing assignments in redis: #{ENV['REDISTOGO_URL']}"
    redis = redis_client
    redis.hmset 'assignments', assignments.to_a.flatten
    redis.set 'generated_at', Time.now.stamp("October 1")
  end

  def self.redis_client
    ENV['REDISTOGO_URL'] ||= 'redis://127.0.0.1:6379'
    uri = URI.parse(ENV['REDISTOGO_URL'])
    Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end

end
