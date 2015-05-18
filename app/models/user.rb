class User < ActiveRecord::Base
  
  devise :database_authenticatable, :recoverable, :registerable, :rememberable, :trackable, :validatable
  
  has_one :profile
  has_many :scriptures, :dependent => :destroy
  
  easy_roles :roles
  
end
