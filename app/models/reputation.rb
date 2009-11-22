require "rubygems"
require 'ruby-growl'

class Tell
  attr_accessor :g
  def initialize(message)
    g = Growl.new("localhost", "ruby-growl", ["ruby-growl Notification"], ["ruby-growl Notification"], nil)
    g.notify("ruby-growl Notification", "Reputation", message, 1, true)
  end
end 

class Reputation
  
  def self.set(direction, record, user, owner)
    model = record.constantize.class_name.downcase
    points = Settings.reputation.fetch(model).fetch(direction)
    Tell.new "#{owner.login}, #{direction}: #{record.constantize.class_name}, Point: #{points}"
    owner.update_attributes :reputation => (owner.reputation + points)
  end
  
  def self.penalize(record, user, owner)
    model = record.constantize.class_name.downcase
    penalty = Settings.reputation.fetch(model).fetch("penalty")
    Tell.new "Penalty of #{penalty} points on #{user.login}"
    reputation = user.reputation.nil?? 0 : user.reputation
    user.update_attributes(:reputation => (reputation + penalty))
  end
  
  def self.unpenalize(record, user, owner)
    model = record.constantize.class_name.downcase
    penalty = Settings.reputation.fetch(model).fetch("penalty")
    Tell.new "Removed penalty: #{user.login} regained #{penalty.abs} points.)"
    reputation = user.reputation.nil?? 0 : user.reputation
    user.update_attributes(:reputation => (reputation + penalty.abs))
  end

end