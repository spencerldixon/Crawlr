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
							head_code = doc.css('head').inner_html
							puts head_code

							#puts head_code

							# AT1
							#puts "  Testing head banner..."
							t1 = head_code.scan("#{urn}").length
							page.update_attributes(head_banner: analyse(t1))

							#puts t1

							# AT2
							#puts "  Testing head mediabar..."
							#t2 = head_code.scan("#{urn}").length
							#page.update_attributes(head_mediabar: analyse(t2))

							#puts t2

							#puts "Testing Body..."
							body_code = doc.css('body').inner_html

							# AT3
							#puts "  Testing body leaderboard"
							t3 = body_code.scan("#{urn}").length
							page.update_attributes(body_banner: analyse(t3))
								      
							# AT4
							#puts "  Testing body mediabar..."
							#t4 = body_code.scan("#{urn}").length
							#page.update_attributes(body_mediabar: analyse(t4))


							#if analyse(t1) == true && analyse(t2) == true && analyse(t3) == true && analyse(t4) == true
							if analyse(t1) == true && analyse(t3) == true	
								page.update_attributes(passed: true)
							else
								page.update_attributes(passed: false)
							end

							#page.update_attributes(error_message: "#{head_code} T1: #{t1}, T2: #{t2}, T3: #{t3}, T4: #{t4}")

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
		site.update_attributes(status: "#{status}")

		if status == "complete"
			NotificationMailer.site_complete(site).deliver
		end
	end

	def analyse(instances)
	    case instances
	    when 0
	    	false
		when 1
			true
	    when 2
	    	true
	    when 3
	    	true
	    else
	    	false
	    end
	end 
end

