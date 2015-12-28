class WawasController < ApplicationController

	# if userid corresponds to an existing user,
	# return that user's username, "" otherwise
	#
	def comments wawaid
		wawa = Wawa.find wawaid
		com = []
		if wawa
			com = wawa.comments
		end
		return com
	end

	# return the username of the author of the 
	# submitted comment
	#
	def comment_username comment
		user = User.find comment.user_id
		username = ""
		if user && user.profile
			username = user.profile.username
		end	
		return username
	end

	helper_method :comments, :comment_username
	
	#------------------------------

	def create

		puts params

		wawa = Wawa.create(wawa_params)
		# wawa.user_id = wawa_params[:user_id]

		# profile = user.profile

		if wawa 
			flash[:notice] = "Thanks for uploading a new Notwa!"
			redirect_to wawa_path wawa
		else
			flash[:alert] = "Updating failed."
			redirect_to new_wawa_path
		end
	end	

	def destroy
	end

	def index
		# this array should be sorted, or queried from the DB
		# in order of most recently added
		#
		@wawas = Wawa.all
	end

	def new
		@wawa = Wawa.new
	end

	def show
		@wawa = Wawa.find params[:id]
		@comments = @wawa.comments

		# check if latitude/longitude is set
		# 
		if @wawa.lat.nil? 
			@wawa.set_latlong_from_pic

			# if lat lon has been set, 
			# get a street address
			if !@wawa.lat.nil?
				@wawa.latlong_to_address
			end
		end

		if !@wawa.street1.nil? || @wawa.street1 == "" 
			if @wawa.lat.nil? 
				# if street address is set and latlon isn't
				# do a reverse geocode and set latlong
				address = "#{@wawa.street1}, #{@wawa.city}, #{@wawa.state}, @wawa.zip"
				location = Geocoder.search( address )
				if location.length > 0
					byebug
					@wawa.lat = location[0].latitude
					@wawa.long = location[0].longitude
				end
			end
		end
	end

	private
	def wawa_params
		params.require(:wawa).permit(:prime_photo, :lat, :long, :street1, :street2, :city, :state, :zip, :info, :user_id)
	end

end
