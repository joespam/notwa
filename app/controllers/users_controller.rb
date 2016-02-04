class UsersController < ApplicationController

	# if userid corresponds to an existing user,
	# return that user's username, "" otherwise
	#
	# def username userid
	# 	user = User.find userid
	# 	retval = ""
	# 	if user
	# 		retval = user.username
	# 	end
	# 	return retval
	# end

	# helper_method :username
	#------------------------------

	def create
		# this code is not getting called. 
		# puts "----------------"
		# puts params
		# puts "----------------"
		@user = User.find(params[:id])
		if @user
			puts "user exists"
		end	
	end

	def edit
		# @user = User.find(params[:id])
		# @profile = @user.profile
		# puts "--------------------------"
	end

	def index
	end

	def show

		# the following if statement is a kludge, but 
		# for the moment, I can't figure out why after_sign_out
		# is not getting called after sign out,
		# so I'm manually redirecting if there is no current_user
		# except that doesn't work, because somehow there is still a current
		# user when we end up in here after following destroy_user_session_path,
		# so IDK WTF
		# if current_user
			# get user
			#
			@user = User.find(params[:id])
			# get profile, or create it and
			# add it to user if it doesn't exist
			#
			@profile = nil
			if @user.profile
				@profile = @user.profile
			else
				@profile = Profile.new(fname:"Empty",lname:"Empty",street1:"Empty",city:"Empty",state:"Empty",zip:"Empty",country:"Empty")
				@user.profile = @profile
			end
		# else
		# 	redirect_to home_path
		# end

	end

	def update
		# user = User.find_by_id params[:id]
		# profile = user.profile
		# if user and profile and profile.update_attributes params[:user]
		# 	flash[:notice] = "Profile updated successfully"
		# 	redirect_to user_path user
		# else
		# 	flash[:alert] = "Updating failed."
		# 	redirect_to edit_user_path user
		# end
	end

	def destroy
	end

end	
