require_relative '../apocalypto_app.rb'
require 'open-uri'
require 'nokogiri'

class ApocalyptoApp::Scraper
    COVID_URL = "https://en.wikipedia.org/wiki/Template:COVID-19_pandemic_data/Per_capita"
    walmart_url = "https://www.walmart.com/"
    food = "search?q=premade+meals&catId=976759_976794_5614446_1797065&sort=best_seller"
    weapons = "search?q=guns&catId=4125_546956_1390220_2909700_1721755&min_price=0&sort=best_seller"

    def get_country_page(url = COVID_URL)
        uri = URI.parse(url)
        Nokogiri::HTML(uri.open)
    end

    def get_food_page(url = walmart_url+food)
        uri = URI.parse(url)
        puts Nokogiri::HTML(uri.open)
    end

    def get_weapon_page(url = walmart_url+weapons)
        uri = URI.parse(url)
        puts Nokogiri::HTML(uri.open)
    end

    def get_countries
        puts "Download game data"

        doc = get_country_page
        countries = doc.css('table#thetable tr').map do |country|
            print "●・○・●"
            name = country.css('td:nth-child(1) a').text.strip
            infected = country.css('td:nth-child(2) span span').text.strip
            {name: name, infected: infected}
        end

        make_countries countries
    end

    def get_food_supplies
        doc = get_food_page
        
    end

    def make_countries countries
        countries.map{|country| ApocalyptoApp::Country.new country}
    end
end