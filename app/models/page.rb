class Page < ActiveRecord::Base
	belongs_to :site

	validates :site_id, presence: true
	validates :uri, presence: true
end
