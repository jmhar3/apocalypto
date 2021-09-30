require_relative '../apocalypto_app.rb'
require 'open-uri'
require 'nokogiri'

class ApocalyptoApp::Scraper
    COVID_URL = "https://en.wikipedia.org/wiki/Template:COVID-19_pandemic_data/Per_capita"
    # FOOD_URL = ""
    WEAPONS_URL = "https://shootersdelight.com.au/product-category/online-gun-store/"

    def get_country_page(url = COVID_URL)
        uri = URI.parse(url)
        Nokogiri::HTML(uri.open)
    end

    def get_weapon_page(url = WEAPONS_URL)
        uri = URI.parse(url)
        Nokogiri::HTML(uri.open)
    end

    def get_countries
        puts "Download game data"

        doc = get_country_page
        countries = doc.css('table#thetable tr').map do |country|
            print "‿︵"
            name = country.css('td:nth-child(1) a').text.strip
            infected = country.css('td:nth-child(2) span').text.strip
            {name: name, infected: infected}
        end

        make_countries countries
    end

    # def get_food
    #     doc = get_food_page

    #     food = doc.css('div.h-100 div.w-100').map do |food|
    #         print "‿︵"
    #         name = food.css('a span').text.strip
    #         value = food.css('.lh-title div.lh-copy').text.strip
    #         {name: name, value: value, type: "health"}
    #     end

    #     make_supplies food
    # end

    def get_weapons
        doc = get_weapon_page
        # binding.pry
        weapons = doc.css('li.product').map do |weapon|
            print "‿︵"
            name = weapon.css('h2.woocommerce-loop-product__title').text.strip
            value = weapon.css('span.price bdi').text.strip[1..-4].gsub(/,/, '')
            {name: name, value: value[0..-2], type: "damage", cost: value}
        end

        make_supplies weapons
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