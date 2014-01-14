class DashboardController < ApplicationController

	before_action :authenticate_user!

	def index
		@user = current_user
		@news = News.last
		@jobs_limit = Job.count.to_f / 100
		@jobs_count = Job.count
		# @sites = Sites.count
	end
end
