class UsersController < ApplicationController
	before_action :signed_in_user, 	only: [:index, :edit, :update, :destroy,
											:following, :followers]
	before_action :correct_user, 	only: [:edit, :update]
	before_action :admin_user, 		only: :destroy

	def index
		@users = User.paginate(page: params[:page], per_page: 3)	
	end

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page], per_page: 3)
	end

	def new
		@user = User.new		
	end

	def create
		@user = User.new(user_params)
		if @user.save
			flash[:success] = "Welcome to the Demo App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
		#既然 correct_user 事前过滤器中已经定义了 @user，edit/update这两个动作中就不再需要再定义 @user 变量了。
		#@user = User.find(params[:id])
	end

	def update
		#@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated"
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed."
		redirect_to users_url
	end

	def following
		@title = "Following"
		@user = User.find_by(params[:id])
		@users = @user.followed_users.paginate(page: params[:page], per_page: 3)
		render 'show_follow'
	end

	def followers
		@title = "Followers"
		@user = User.find_by(params[:id])
		@users = @user.followers.paginate(page: params[:page], per_page: 3)
		render 'show_follow'
	end
		

	private 

		def user_params
			params.require(:user).permit(:first_name, :last_name, 
				:email, :gender, :password, :password_confirmation)
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end

		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
end
