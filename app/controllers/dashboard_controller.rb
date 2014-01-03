class DashboardController < ApplicationController

	before_action :authenticate_user!

	def index
		@user = current_user
		@news = News.last
	end
end
