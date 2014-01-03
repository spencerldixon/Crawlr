module JobsHelper
	def alert(job_status)
		if job_status == "pending"
			"default"
		elsif job_status == "crawling"
			"warning"
		elsif job_status == "complete"
			"success"
		elsif job_status == "failed"
			"danger"
		end
	end
end
