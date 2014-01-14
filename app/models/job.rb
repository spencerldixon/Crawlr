class Job < ActiveRecord::Base
	belongs_to :user

	validates :user_id, presence: true
	validates :url, presence: true
	validates :keyword, presence: true
	validates :url, :format => { :with => URI::regexp(%w(http https)), :message => "Valid URL required"}

	
end
