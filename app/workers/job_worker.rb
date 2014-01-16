class CrawlerWorker
	include SuckerPunch::Job

	def perform(job_id)
		job = Job.find(job_id)
		update_status("crawling", job)

		#SET LOCAL VARIABLES
		start_crawl = Time.now
		url = job.url
		keyphrase = job.keyword
		founds = Array.new
		total, totalkeywords, errorcount = 0, 0, 0

		puts "\nPAGES CONTAINING KEYWORD:"

		#file = CSV.open("Crawler-Report-For-#{url.gsub("http://www.", '').gsub(".", '')}.csv", "w") do |csv|
		#csv << ["Site URL", "Page ID", "Page URI", "Fetched?", "Keyword/Keyphrase", "Instances Found", "Error Message"]

		begin
			Anemone.crawl(url, 
				:depth_limit => 1, 
				:obey_robots_txt => true, 
				:skip_query_strings => false, 
				:read_timeout => 4) do |anemone|

				anemone.on_every_page do |page|
				begin

				  	total += 1

				  	if page.fetched? and page.html?
				  		fetched = true
					  	doc = Nokogiri::HTML(open(page.url))

					  		keyphrase_instance = page.doc.inner_text.downcase.scan(keyphrase.downcase).length

							if keyphrase_instance.to_i > 0
								print "  Found #{keyphrase_instance} matches for the keyphrase \"#{keyphrase.downcase}\" on the page "
								print page.url
								#founds << page.url
								print "\n"
							else
								print "  No matches found for the keyphrase \"#{keyphrase.downcase}\" on the page "
								print page.url
								print "\n"
							end

						totalkeywords += keyphrase_instance.to_i

					elsif page.not_found?
						fetched = false
						puts "  404 Received. The page could not be found."
						errorcount += 1
					else
						fetched = false
						puts "  The page could not be fetched or was not a valid HTML document."
						errorcount += 1
					end

					rescue => e
						fetched = false
						errormessage = "  An error occured! #{e.message}"
						puts errormessage
						errorcount += 1
						next
					end

					#csv << [url, total, page.url, fetched, keyphrase, keyphrase_instance, errormessage]
				end
			end



			endcrawl = Time.now
			duration = endcrawl - start_crawl
			totalcrawltime = ChronicDuration.output(duration.to_i, :format => :long)

			#csv << [""]
			#csv << ["Crawl Completed In:", totalcrawltime]
			#csv << ["Total Pages Crawled:", total]
			#csv << ["Total Errors:", errorcount]
			#csv << ["Total Keyphrases Found:", totalkeywords]
			#csv << ["Total Pages Containing Keyphrases:", founds.length]
		#end

		#parsed_file = CSV.parse(file, :headers => true, :skip_blanks => true)

		#job.update_attributes(binary_data: parsed_file)

		rescue
			job.update_attributes(status: "failed")

		end

		#NotificationMailer.job_complete(job).deliver
		#job.update_attributes(status: "complete")
		update_status("complete", job)
	end

	def update_status(status, job)
		if status == "complete"
			NotificationMailer.job_complete(job).deliver
		end

		job.update_attributes(status: "#{status}")
	end

end

