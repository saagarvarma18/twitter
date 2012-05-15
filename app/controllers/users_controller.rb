class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index,:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,:only => :destroy


  def index
    @users = User.paginate(:page => params[:page])
    @title = "All users"
  end

  def show
    @user= User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    #@microposts = @user.microposts
    @title=@user.name
  end

  
  def new
  	@user= User.new
  	@title='Sign Up'
  end

  def destroy
    @user.destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end


  def create
  	@user=User.new(params[:user])
  	if @user.save
      sign_in @user
      UserMailer.welcome_email(@user).deliver
  		redirect_to @user, :flash => { :success => " Welcome to the Sample App!"  }
  	else
		@title="Bazinga"
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit User"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Profile Updated!"  }
    else
      @title= "Edit User"
      render 'edit'
    end
  end

  private

  def authenticate
    deny_access unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end  

  def admin_user
    @user = User.find(params[:id]) 
    redirect_to(root_path) unless current_user.admin?
  end

end