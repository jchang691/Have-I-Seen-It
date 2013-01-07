class UsersController < ApplicationController

	def show
		@user = User.find(params[:id])
	end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the HaveISeenIt!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
	
		def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
