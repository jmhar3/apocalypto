class ApocalyptoApp::CLI
    include ApocalyptoApp

    def initialize
        ApocalyptoApp::Scraper.new.get_countries
        # ApocalyptoApp::Scraper.new.get_food
        ApocalyptoApp::Scraper.new.get_weapons
    end

    def start
        system("clear")
        puts "Welcome to Apocalypto"
        divider
        new_line
        puts "It's the end of days. A plague has taken over the world, turning people into vicious, flesh eating zombies. The world as you know it is over. Your job now? Survive."
        new_line
        puts "Enter your name to begin"
        puts "Input [exit] to escape the apocalypse."

        input = gets.strip.downcase
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
        divider
        country.each.with_index(1) do |country, i|
            puts "#{i}. #{country.name} - #{country.difficulty}"
        end
        prompt_area_selection
    end

    def prompt_area_selection
        divider
        new_line
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