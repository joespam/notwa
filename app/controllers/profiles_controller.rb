class ProfilesController < ApplicationController

	def edit

		@user = User.find(params[:user_id])
		@profile = @user.profile
	end

	def update
		user = User.find_by_id params[:user_id]
		profile = user.profile

		if user and profile and profile.update_attributes profile_params
			flash[:notice] = "Profile updated successfully"
			redirect_to user_path user
		else
			flash[:alert] = "Updating failed."
			redirect_to edit_user_profile_path user
		end
	end	

	private
	def profile_params
		params.require(:profile).permit(:username, :fname, :lname, :avatar, :street1, :street2, :city, :state, :zip)
	end

end
