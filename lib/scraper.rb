require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    all_students = []
    
    page.css("div.student-card").each do |student|
      name = student.css("h4.student-name").text 
      location = student.css("p.student-location").text
      profile_url = student.css("a").attribute("href").value 
      student_details = {
        :name => name,
        :location => location,
        :profile_url => profile_url
      }
      all_students << student_details
    end 
    all_students 
  end 
  
  def self.scrape_profile_page(profile_url)
      profile_page = Nokogiri::HTML(open(profile_url))
      student = {}

      container = profile_page.css(".social-icon-container a").collect{|icon| icon.attribute("href").value}
      
      container.each do |url|
        if url.include?("twitter")
          student[:twitter] = url
        elsif url.include?("linkedin")
          student[:linkedin] = url
        elsif url.include?("github")
          student[:github] = url
        elsif url.include?(".com")
          student[:blog] = url
        end
      end
      student[:profile_quote] = profile_page.css(".profile-quote").text
      student[:bio] = profile_page.css("div.description-holder p").text
      student
  end

end
