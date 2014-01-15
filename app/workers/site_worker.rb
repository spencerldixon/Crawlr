class SiteWorker
	include SuckerPunch::Job

	def perform(site_id)
		site = Site.find(site_id)
		update_status("crawling", site)

		#SET LOCAL VARIABLES
		start_crawl = Time.now


		url = site.url

		begin
			Anemone.crawl(url, 
				:depth_limit => 1, 
				:obey_robots_txt => true, 
				:skip_query_strings => false, 
				:read_timeout => 4) do |anemone|

				anemone.on_every_page do |page|
				begin
				  	if page.fetched? and page.html?
				  		fetched = true
					  	doc = Nokogiri::HTML(open(page.url))

					  	puts page.url
					  	site.pages.build(uri: "#{page.url.to_s}")

					  		#SEARCH STUFF HERE


					elsif page.not_found?
						page.update_attributes(passed: false, error_message: "404 Received. The page could not be found.")
					else
						page.update_attributes(passed: false, error_message: "The page could not be fetched or was not a valid HTML document.")
					end

					rescue => e
						page.update_attributes(passed: false, error_message: "An error occured! #{e.message}")
						next
					end
				end
			end

			Passed
			Error_message
			basic_test
			head_banner
			head_mediabar
			body_banner
			body_mediabar
			uri

			duration = Time.now - start_crawl
			totalcrawltime = ChronicDuration.output(duration.to_i, :format => :long)
			site.update_attributes(crawl_time: totalcrawltime)
		rescue
			update_status("failed", site)
		end
		update_status("complete", site)
	end

	# Methods
	def update_status(status, site)
		if status == "complete"
			NotificationMailer.site_complete(site).deliver
		end

		site.update_attributes(status: "#{status}")
	end

	def analyse(instances)
	    case instances
		    when 1
		      "Passed"
		    when 0
		      "Failed"
		    when 2
		      "Failed (Initially marked as failed, however some sites may have more than one orientation of ad unit"
		    else
		      "Failed - Far too many instances"
	    end
	end 
end

