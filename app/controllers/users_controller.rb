class UsersController < ApplicationController

	# if userid corresponds to an existing user,
	# return that user's username, "" otherwise
	#
	def username userid
		user = User.find userid
		retval = ""
		if user
			retval = user.username
		end
		return retval
	end

	helper_method :username
	#------------------------------

	def create
		# this code is not getting called. 
		puts "----------------"
		puts params
		puts "----------------"
		@user = User.find(params[:id])
		if @user
			puts "user exists"
		end	
	end

	def edit
		# @user = User.find(params[:id])
		# @profile = @user.profile
		puts "--------------------------"
	end

	def index
	end

	def show
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
			@profile = Profile.new
			@user.profile = @profile
		end

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
