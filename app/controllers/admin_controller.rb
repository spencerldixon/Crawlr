class AdminController < ApplicationController

	before_action :authenticate_user!
	before_action :user_is_admin

	def index
		@users = User.all
	end

	private
		def user_is_admin
		  (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.admin?)
		end
end
