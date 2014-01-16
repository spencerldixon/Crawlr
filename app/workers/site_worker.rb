class SiteWorker
	include SuckerPunch::Job

	def perform(site_id)
		site = Site.find(site_id)
		update_status("crawling", site)

		#SET LOCAL VARIABLES
		start_crawl = Time.now


		url = site.url
		urn = site.urn

		begin
			Anemone.crawl(url, 
				:depth_limit => 1, 
				:obey_robots_txt => true, 
				:skip_query_strings => false, 
				:read_timeout => 3) do |anemone|

				anemone.on_every_page do |anemonepage|
				begin
					if anemonepage.fetched? and anemonepage.html?
						doc = Nokogiri::HTML(open(anemonepage.url))

						  	page = site.pages.build(uri: "#{anemonepage.url.to_s}")

						  	#puts "Testing Head..."
							#head_code = doc.css('head').inner_html

							# AT1
							#puts "  Testing head banner..."
							#t2 = analyse(head_code.scan("#{urn}_PB").length)

							# AT2
							#puts "  Testing head mediabar..."
							#t2 = analyse(head_code.scan("#{urn}_PA").length)

							#puts "Testing Body..."
							body_code = doc.css('body').inner_html

							# AT3
							#puts "  Testing body leaderboard"
							error = body_code.scan("#{urn}_PB").length

							page.update_attributes(error_message: error)
								      
							# AT4
							#puts "  Testing body mediabar..."
							#t4 = analyse(body_code.scan("#{urn}_PA").length)

							#puts t1
							#puts t2
							#puts t3
							#puts t4

							page.update_attributes(passed: true)

							#puts page


					elsif anemonepage.not_found?
							page.update_attributes(passed: false, error_message: "404 Received. The page could not be found.")
					else
							page.update_attributes(passed: false, error_message: "The page could not be fetched or was not a valid HTML document.")
					end

					rescue => e
						#page.update_attributes(passed: false, error_message: "An error occured! #{e.message}")
						next
					end
				end
			end
			
			duration = Time.now - start_crawl
			site.update_attributes(crawl_time: duration)

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
		      true
		    when 0
		      false
		    when 2
		      false # (Initially marked as failed, however some sites may have more than one orientation of ad unit
		    else
		      false #Far too many instances
	    end
	end 
end

