class ApocalyptoApp::CLI
    include ApocalyptoApp

    @@all = []

    def initialize
        ApocalyptoApp::Supply.new name: "Resurrection Potion", type: "revive", value: 50, cost: "800", desc: "A mystical potion to bring you back from the depths of hell."
        ApocalyptoApp::Supply.new name: "apple", type: "health", value: 10, cost: "10", desc: "A mystical apple"
        ApocalyptoApp::Supply.new name: "stick", type: "damage", value: 10, cost: "10", desc: "A mystical stick"
        ApocalyptoApp::Scraper.new.get_countries
        ApocalyptoApp::Scraper.new.get_weapons
        @@all << self
    end

    def self.all
        @@all
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