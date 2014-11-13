class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:douban]


  def self.new_with_session(params,session)
    super.tap do |user|
      omni=session[:omni].try(:symbolize_keys)
      if omni
        session[:omni] = nil
        user.provider = omni[:provider]
        user.uid = omni[:uid]
      end
    end
  end
end
