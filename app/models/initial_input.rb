class InitialInput < ActiveRecord::Base
  attr_accessible :description, :title, :user_id
  belongs_to :user

  has_many :data_files, :dependent => :delete_all

end
