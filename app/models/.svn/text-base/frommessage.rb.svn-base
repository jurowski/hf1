class Frommessage < ActiveRecord::Base
  validates_presence_of :subject
  validates_uniqueness_of :body, :scope => [:from_id, :to_id, :subject], :message => "This message has already been sent."
end
