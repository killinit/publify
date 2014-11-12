class Flag < ActiveRecord::Base
  belongs_to :feedback

  validates_presence_of :explanation
end
