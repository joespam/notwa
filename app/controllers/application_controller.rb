class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	#redirect to user page after sign in/out
	def after_sign_in_path_for(resource)
		user_path current_user
	end

	def after_sign_out_path_for(resource)
		home_path
	end

end