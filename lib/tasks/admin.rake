namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(first_name: "Spencer",
    			 last_name: "Dixon",
                 email: "spencer.dixon@fendixmedia.co.uk",
                 password: "fendix815",
                 password_confirmation: "fendix815")
    admin.toggle!(:admin)

    News.create!(message: "Hello World. This is a seed message...")
  end
end