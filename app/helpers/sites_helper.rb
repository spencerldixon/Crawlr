module SitesHelper
	def alert(site_status)
		if site_status == true
			"success"
		elsif site_status == false
			"danger"
		elsif site_status == "pending"
			"default"
		elsif site_status == "crawling"
			"warning"
		elsif site_status == "complete"
			"success"
		elsif site_status == "failed"
			"danger"
		end
	end

	def results_style(coverage)
		if coverage > 70
			"success"
		else
			"danger"
		end
	end

	def glyphicon(boolean)
		if boolean == true
			"glyphicon glyphicon-ok"
		else
			"glyphicon glyphicon-remove"
		end
	end
end
