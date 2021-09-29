require_relative '../apocalypto_app.rb'

class ApocalyptoApp::Scraper
    COVID_URL = "https://www.worldometers.info/coronavirus/#countries"
    WALMART_URL = "https://www.walmart.com/"
    FOOD = "search?q=premade+meals&catId=976759_976794_5614446_1797065&sort=best_seller"
    WEAPONS = "search?q=guns&catId=4125_546956_1390220_2909700_1721755&min_price=0&sort=best_seller"

    def get_food_page(url = WALMART_URL+FOOD)
        uri = URI.parse(url)
        puts Nokogiri::HTML(uri.open)
    end

    def get_weapon_page(url = WALMART_URL+WEAPONS)
        uri = URI.parse(url)
        puts Nokogiri::HTML(uri.open)
    end

    def get_country_page(url = COVID_URL)
        uri = URI.parse(url)
        puts Nokogiri::HTML(uri.open)
    end

    def get_supplies
    end

    def get_countries
    end
end