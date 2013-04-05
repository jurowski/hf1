class Tag < ActiveRecord::Base

  has_many :goaltags
  has_many :goaltemplates, :through => :goaltags

  has_many :program_tags
  has_many :programs, :through => :program_tags


  has_many :template_tags
  ### the below might not work right... will have to test
  has_many :templates, :through => :template_tags

  has_many :message_tags
  has_many :messages, :through => :message_tags

  belongs_to :organization
  #belongs_to :program ### we already have :program_tags

end
