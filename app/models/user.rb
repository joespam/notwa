class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	      :recoverable, :rememberable, :trackable, :validatable

	has_many :comments
	has_many :pictures
	has_many :wawas
	has_one :profile

	validates :username,
		:presence => true,
		:uniqueness => {
			:case_sensitive => false
		}
	validates :email, 
		:presence => true, 
		:uniqueness => true

	# to prevent users from using an existing user's email
	# as a username
	validate :validate_username

	def validate_username
	  if User.where(email: username).exists?
	    errors.add(:username, :invalid)
	  end
	end

	# Virtual attribute for authenticating by either username or email
	# This is in addition to a real persisted field like 'username'
	attr_accessor :login

	# overwrite the find_for_database_authentication method
	# to allow users to login with email OR username
	#
	def self.find_for_database_authentication(warden_conditions)
		conditions = warden_conditions.dup
		if login = conditions.delete(:login)
			where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
		else
			conditions[:email].downcase! if conditions[:email]
			where(conditions.to_hash).first
		end
	end

	# after_create :add_profile

	# we want a user to have and be known by their username
	# username lives on a profile. So creating a new user
	# will automatically create a profile using everything
	# before the '@' in their email as the username.
	# def add_profile

	# 	username = Profile.username_from_email self.email
	# 		puts "-------------------------------- #{username}"
	# end

 #  # return the username stored in the user's profile
 #  def username
 #  		username = ""
 #  		if this.profile.exists?
 #  			username = profile.username
 #  		end
 #  		return username
 #  end

end
