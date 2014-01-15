class NotificationMailer < ActionMailer::Base
  default from: "spencer.dixon@fendixmedia.co.uk"

  def job_complete(job)
  	@user = job.user
  	@job = job

  	mail to: job.user.email,
  		subject: "Your Crawl has Completed!",
  		from: "spencer.dixon@fendixmedia.co.uk"
  end

  def site_complete(site)
  	@user = site.user
  	@site = site

  	mail to: site.user.email,
  		subject: "Your Crawl has Completed!",
  		from: "spencer.dixon@fendixmedia.co.uk"
  end
end
