class PasswordResetsController < ApplicationController
  def new
  end

  def create
  user = User.find_by_email(params[:email])
  if user.nil?
    redirect_to new_password_reset_url,:notice => "Please enter a valid Email ID"
  else
  user.send_password_reset 
  redirect_to root_url, :notice => "Email sent with password reset instructions."
  end
end

def edit
  @user = User.find_by_password_reset_token!(params[:id])
end

def update
  @user = User.find_by_password_reset_token!(params[:id])
  if @user.password_reset_sent_at < 2.hours.ago
    redirect_to new_password_reset_path, :alert => "Password reset has expired."
  elsif @user.update_attributes(params[:user])
    redirect_to root_url, :notice => "Password has been reset!"
  else
    render :edit
  end
end
end
