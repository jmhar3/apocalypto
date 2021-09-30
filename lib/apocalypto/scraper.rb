require_relative '../apocalypto_app.rb'
require 'open-uri'
require 'nokogiri'

class ApocalyptoApp::Scraper
    COVID_URL = "https://en.wikipedia.org/wiki/Template:COVID-19_pandemic_data/Per_capita"
    # FOOD_URL = ""
    WEAPONS_URL = "https://shootersdelight.com.au/product-category/online-gun-store/"

    def get_page url
        uri = URI.parse(url)
        Nokogiri::HTML(uri.open)
    end

    def get_countries
        puts "Download game data"

        doc = get_page COVID_URL
        countries = doc.css('table#thetable tr').map do |country|
            print "‿︵"
            name = country.css('td:nth-child(1) a').text.strip
            infected = country.css('td:nth-child(2) span').text.strip
            {name: name, infected: infected}
        end

        make_countries countries
    end

    def get_weapons
        doc = get_page WEAPONS_URL
        # binding.pry
        weapons = doc.css('li.product').map do |weapon|
            print "‿︵"
            name = weapon.css('h2.woocommerce-loop-product__title').text.strip
            value = weapon.css('span.price bdi').text.strip[1..-4].gsub(/,/, '')
            url = weapon.css('a').attr("href").value.strip 
            desc =  get_weapon_desc url
            {name: name, value: value[0..-2], type: "damage", cost: value, desc: desc}
        end

        make_supplies weapons
    end

    def get_weapon_desc url
        doc = get_page url
        doc.css('div#tab-description p:first-child').text.strip
      end

    def make_supplies supplies
        supplies.map{|supply| ApocalyptoApp::Supply.new supply}
    end

    def make_countries countries
        countries.map do |country|
            new_country = ApocalyptoApp::Country.new country
            zombies = ApocalyptoApp::Zombie.generate_zombies new_country.infected.split(",").join.to_i, new_country.difficulty, new_country
        end
    end
end