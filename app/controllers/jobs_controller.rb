class JobsController < ApplicationController
	before_action :authenticate_user!

	def index
		@user = current_user

		if current_user.jobs.any?
			@jobs = current_user.jobs
		else
			@jobs = []
		end
	end

	def new
		@job = current_user.jobs.build
	end

	def create
		@job = current_user.jobs.build(job_params)

		if @job.save
			CrawlerWorker.new.async.perform(@job.id)
			flash[:success] = "Job queued successfully"
			redirect_to jobs_path

		else
			flash[:danger] = "Job failed! Please try again"
			redirect_to jobs_path
		end
	end

	def destroy
		@job = Job.find(params[:id])
		if @job.present?
			@job.destroy
			flash[:success] = "Job deleted successfully!"
		end

		redirect_to jobs_path
	end

	private
		def job_params
			params.require(:job).permit(:url, :keyword)
		end
end
