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
		if user && user.username
			username = user.username
		end	
		return username
	end

	# given a wawa record, fill in any missing info
	# we can based on the information we do have
	#
	def geofill wawa
		# if no lat/long, but there is a pic
		# attempt to extract latlong data from pic
		# 

		if wawa.lat.nil? && wawa.prime_photo_file_name
			wawa.set_latlong_from_pic
		end

		if wawa.lat && wawa.street1.nil? || wawa.street1 == "" 
			# if lat lon has been set but there's no address
			# get a street address from latlong
			if !wawa.lat.nil?
				wawa.latlong_to_address
				wawa.save
			end
		elsif !wawa.street1.nil? || wawa.street1 != "" 			
			# if street address is set and latlon isn't
			# do a reverse geocode and set latlong
			# 
			if wawa.lat.nil? 

				address = "#{wawa.street1}, #{wawa.city}, #{wawa.state}, #{wawa.zip}"
				location = Geocoder.search( address )
				if location.length > 0
					wawa.lat = location[0].latitude
					wawa.long = location[0].longitude
					wawa.save
				end
			end
		end
	end

	helper_method :comments, :comment_username, :geofill
	
	#------------------------------

	def create

		puts params

		wawa = Wawa.create(wawa_params)
		# wawa.user_id = wawa_params[:user_id]

		# profile = user.profile
		geofill wawa
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

	def edit
		# puts "-------------------------"
		# puts params
		# puts "-------------------------"

		@wawa = Wawa.find params[:id]
		@user = @wawa.user
	end

	def index
		# this array should be sorted, or queried from the DB
		# in order of most recently added
		#
		@wawas = Wawa.all
		@hash = Gmaps4rails.build_markers(@wawas) do |wawa, marker|
			wawa_link = view_context.link_to "show me!", wawa_path(wawa.id)
			marker.infowindow "<h4><u>#{wawa_link}</u></h4>"
			marker.lat wawa.lat
			marker.lng wawa.long
		end
	end

	def new
		@wawa = Wawa.new
	end

	def show
		@wawa = Wawa.find params[:id]
		@comments = @wawa.comments
		@comment = Comment.new
		# @comments_hash = Hash[*@comments.map{ |c| [c.id, c.body] }.flatten]

		geofill @wawa
		# check if latitude/longitude is set
		# 
		# if @wawa.lat.nil? && @wawa.prime_photo_file_name
		# 	@wawa.set_latlong_from_pic

		# 	# if lat lon has been set, 
		# 	# get a street address
		# 	if !@wawa.lat.nil?
		# 		@wawa.latlong_to_address
		# 	end
		# end

		# if !@wawa.street1.nil? || @wawa.street1 != "" 
		# 	if @wawa.lat.nil? 
		# 		# if street address is set and latlon isn't
		# 		# do a reverse geocode and set latlong
		# 		address = "#{@wawa.street1}, #{@wawa.city}, #{@wawa.state}, #{@wawa.zip}"
		# 		location = Geocoder.search( address )
		# 		if location.length > 0
		# 			@wawa.lat = location[0].latitude
		# 			@wawa.long = location[0].longitude
		# 			@wawa.save
		# 		end
		# 	end
		# end

		# now that we know we have a lat long, create a hash so we
		# can put a marker on the map location
		wawas = []
		wawas[0] = @wawa
		@hash = Gmaps4rails.build_markers(wawas) do |wawa, marker|
		  marker.lat wawa.lat
		  marker.lng wawa.long
		end
	end

	def update

		wawa = Wawa.find params[:id]
		if wawa and wawa.update_attributes wawa_params
			# change the street address just in case lat long changed
			if wawa.save
				wawa.latlong_to_address

				if wawa.save
					flash[:notice] = "Wawa updated successfully"
					redirect_to wawa_path wawa
				else
					flash[:alert] = "Updating failed."
					redirect_to edit_wawa_path wawa
				end		
			else
				flash[:alert] = "Updating failed."
				redirect_to edit_wawa_path wawa
			end			
		else
			flash[:alert] = "Updating failed."
			redirect_to edit_wawa_path wawa
		end
	end

	private
	def wawa_params
		params.require(:wawa).permit(:prime_photo, :lat, :long, :street1, :street2, :city, :state, :zip, :info, :user_id)
	end

end
