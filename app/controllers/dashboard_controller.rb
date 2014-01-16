class DashboardController < ApplicationController

	before_action :authenticate_user!

	def index
		@user = current_user
		@news = News.last
		@crawl_limit = Page.count.to_f / 100
		@crawl_count = Page.count
		# @sites = Sites.count
	end
end
