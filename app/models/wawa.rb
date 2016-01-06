class Wawa < ActiveRecord::Base

	has_many :comments
	has_many :pictures
	belongs_to :user

	# paperclip validations
	#
	has_attached_file :prime_photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :prime_photo, content_type: /\Aimage\/.*\Z/

	# get the lat long coords from the EXIF data from photo
	# imgname. Returns { :lat => val, :long => val2} if successful,
	# {} if such data is not present or it fails
	#
	def latlong_from_pic
		# check file for presence of lat, long
		#
		retval = {}
		exifimg = EXIFR::JPEG.new(self.prime_photo.path)
		if exifimg && exifimg.gps?
			retval = { :lat => exifimg.gps[0], :long => exifimg.gps[1]}
		end

		return retval
	end

	def set_latlong_from_pic
		# check file for presence of lat, long
		#
		latlong = self.latlong_from_pic
		if !latlong.empty?
			self.lat = latlong[:lat]
			self.long = latlong[:long]	
			self.save	
		end
	end

	# get  latlong data from, set the address attributes from that
	#
	def latlong_to_address

		if (self.lat)
			address = Geocoder.address([self.lat,self.long])
			if address
				# sample address is 
				# "769 Lasalle St, New Orleans, LA 70113, USA" 
				# 
				fields = address.split ','
				if fields.length == 4
					# need to split up the state and zip, at index 2
					statezip = fields[2].split " "

					self.street1 = fields[0]
					self.city = fields[1]

					self.state = statezip[0]
					self.zip = statezip[1]
				else
					flash[:notice] = "Please set the Notwa address to #{address}"
				end
			end
		end
	end
end
