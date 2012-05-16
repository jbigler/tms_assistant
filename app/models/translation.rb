class Translation < ActiveRecord::Base
  
  validates_presence_of :locale, :key
  attr_accessible :locale, :key, :value            

end
