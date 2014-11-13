class Users::OmniauthCallbacksController < ApplicationController
  def douban
    auth = @omniauth = env['omniauth.auth']
    @user = from_omniauth(auth, auth.email)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      # set_flash_message(:notice, :success, :kind => "Douban") if is_navigational_format?
    else
      # raise "cannot create: provider doesn't provide email"
      session[:omni] = {provider:@user.provider, uid:@user.uid}
      redirect_to new_user_registration_url
    end
  end
  private
  def from_omniauth(auth, email=nil)
    User.where(provider:auth.provider, uid:auth.uid).first_or_create do |user|
      user.email = email #auth.email || "#{auth.uid}@#{auth.provider}"+".cc"
      user.password = Devise.friendly_token[0,20]
    end
  end
end
