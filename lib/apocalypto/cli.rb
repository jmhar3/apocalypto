class ApocalyptoApp::CLI
    include ApocalyptoApp::Utility

    @@all = []

    def initialize
        starter_supplies
        ApocalyptoApp::Scraper.new.get_countries
        ApocalyptoApp::Scraper.new.get_weapons
        @@all << self
    end

    def self.all
        @@all
    end

    def starter_supplies
        ApocalyptoApp::Supply.new name: "Resurrection Potion", type: "revive", value: 50, cost: "800",
            desc: "A mystical potion to bring you back from the depths of hell."
        ApocalyptoApp::Supply.new name: "Red Bull", type: "health", value: 10, cost: "100", desc: "A mystical apple"
        ApocalyptoApp::Supply.new name: "Crowbar", type: "damage", value: 30, cost: "300", desc: "A mystical stick"
        ApocalyptoApp::Supply.new name: "Zippo", type: "damage", value: 10, cost: "100", desc: "A mystical stick"
        ApocalyptoApp::Supply.new name: "Kitchen Knife", type: "damage", value: 5, cost: "50", desc: "A mystical stick"
        ApocalyptoApp::Supply.new name: "Canned Tuna", type: "health", value: 30, cost: "60", desc: "A mystical stick"
        ApocalyptoApp::Supply.new name: "SPAM", type: "health", value: 45, cost: "90", desc: "A mystical stick"
        ApocalyptoApp::Supply.new name: "Aerosol Deoderant", type: "health", value: 20, cost: "40", desc: "A mystical stick"
    end

    def start
        system("clear")
        puts "Welcome to Apocalypto"
        divider
        puts "It's the end of days. A plague has taken over the world, turning people into vicious, flesh eating zombies. The world as you know it is over. Your job now? Survive."
        new_line
        puts "Enter your name to begin"
        puts "Input [exit] to escape the apocalypse."

        input = gets.strip.downcase.capitalize
        if input == "exit"
            exit
        else
            ApocalyptoApp::Player.new(name: input)
            list_countries
        end
    end

    def list_countries
        system("clear")
        puts "Choose your starting area:"
        new_line
        country.each.with_index(1) do |country, i|
            puts "#{i}. #{country.name} - #{country.difficulty}"
        end
        prompt_area_selection
    end

    def prompt_area_selection
        divider
        puts "Please enter a number to select your starting area."
        escape

        input = get_user_input
        input == 0 ? exit : country[input - 1].welcome
    end

    def get_user_input
        input = gets.strip.to_i
        if input > country.size
            puts "Invalid selection: No country exists."
            puts "Please input a valid number."
            return get_user_input
        end
        input
    end

    def country
        ApocalyptoApp::Country.all
    end
end