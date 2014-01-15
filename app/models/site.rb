class Site < ActiveRecord::Base
	belongs_to :user
	has_many :pages, dependent: :destroy

	validates :user_id, presence: true
	validates :url, presence: true
	validates :urn, presence: true
	validates :url, :format => { :with => URI::regexp(%w(http https)), :message => "Valid URL required"}
end
