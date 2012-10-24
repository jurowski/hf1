class AddTestimonialrequestToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :asked_for_testimonial, :boolean, :default => false
  end

  def self.down
    remove_column :users, :asked_for_testimonial
  end
end
