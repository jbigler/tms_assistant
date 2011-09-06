# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
# Setup initial user so we can get in
user = User.create! :name => "Jeff Bigler", :email => "jbigler@saturnstudio.com", :password => "password", :password_confirmation => "password"
user.confirmed_at = user.confirmation_sent_at
user.admin = true
user.save
