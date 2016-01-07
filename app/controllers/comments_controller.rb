class CommentsController < ApplicationController

	def create
		contents = params[:comment]

		Comment.create(body: contents[:body], 
							user_id: params[:user_id], 
							wawa_id: params[:wawa_id])

		redirect_to wawa_path(params[:wawa_id])
	end

	def update
		comment = Comment.find params[:id]
		contents = params[:comment]

		if comment
			comment.body = contents[:body]
			if comment.save
				redirect_to wawa_path(comment.wawa_id)
			else
				flash[:alert] = "Sorry, this comment cannot be updated at this time."
				redirect_to home_path
			end
		else
			flash[:alert] = "Sorry, this comment cannot be updated at this time."
			redirect_to home_path
		end
	end

end
