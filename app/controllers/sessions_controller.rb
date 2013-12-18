class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			#sign in success
			sign_in user
			redirect_back_or user
		else
			#show errer message
			flash.now[:error] = 'Invalid email/password !'
			render 'new'
		end
	end

	def destroy
		sign_out
    	redirect_to root_path
	end
end
