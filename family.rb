require 'redis'
require 'stamp'

class Family
  def self.members
    [ ['Mattie',
       'Kriddie',
       'Katherine / Scriba'],

      ['Claire / Josh',
       'Samuel / Jordan',
       'Sarabeth',
       'Carol / Frank'],

       ['John / Sharon',
        'Thomas / Elizabeth',
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

    redis = Redis.new
    redis.hmset 'assignments', assignments.to_a.flatten
    redis.set 'generated_at', Time.now.stamp("Jan 1 at 01:00 AM")
  end

end
