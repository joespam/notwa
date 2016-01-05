class Profile < ActiveRecord::Base
	belongs_to :user

	# paperclip validations
	#
	has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

	# given a valid email address, set the
	# part before the '@' as the username
	#
	# def username_from_email email
	# 			byebug
	# 	username = ""
	# 	if email.include? "@"
	# 		tokens = email.split "@"
	# 		username = tokens[0] if tokens.length > 0
	# 	end
	# 	return username
	# end
end
