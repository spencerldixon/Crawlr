class SitesController < ApplicationController
	before_action :authenticate_user!

	def index
		@user = current_user
		@sites = Site.all
		@crawl_limit = Page.count.to_f / 100
		@crawl_count = Page.count
	end

	def new
		@site = current_user.sites.build
	end

	def create
		@site = current_user.sites.build(site_params)

		if @site.save
			SiteWorker.new.async.perform(@site.id)
			flash[:success] = "Site created and crawl queued successfully!"
			redirect_to sites_path

		else
			flash[:danger] = "Site creation failed! Please try again"
			redirect_to sites_path
		end
	end

	def show
		@site = Site.find(params[:id])
		@coverage = @site.pages.where(:passed => true).count.to_f / @site.pages.count.to_f * 100
	end

	def destroy
		@site = Site.find(params[:id])
		if @site.present?
			@site.destroy
			flash[:success] = "Site and dependent Pages deleted successfully!"
		end

		redirect_to sites_path
	end

	private
		def site_params
			params.require(:site).permit(:url, :urn)
		end
end
