class Dream < ActiveRecord::Base
  validates_presence_of :title, :description
  validates_length_of :description, :minimum => 10, :maximum => 500
end
