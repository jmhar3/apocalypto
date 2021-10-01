class ApocalyptoApp::CLI
    include ApocalyptoApp::Utility
    attr_accessor :starter_items

    @@all = []

    def initialize
        @starter_items = []
        starter_health
        starter_damage
        ApocalyptoApp::Scraper.new.get_countries
        ApocalyptoApp::Scraper.new.get_weapons
        @@all << self
    end

    def self.all
        @@all
    end

    
    # DRY THIS OUT | CREATE MULTIPLE INSTANCES AT ONCE?

    def starter_health
        res = ApocalyptoApp::Supply.new name: "Resurrection Potion", type: "revive", value: 50, cost: "800", desc: "A mystical potion to bring you back from the depths of hell."
        food = ApocalyptoApp::Supply.new name: "Red Bull", type: "health", value: 15, cost: "30", desc: "Gamer fuel."
        ApocalyptoApp::Supply.new name: "Canned Tuna", type: "health", value: 35, cost: "70", desc: "A canned delicacy in this new age."
        ApocalyptoApp::Supply.new name: "SPAM", type: "health", value: 45, cost: "90", desc: "A canned delicacy in this new age."
        ApocalyptoApp::Supply.new name: "Aerosol Deoderant", type: "health", value: 20, cost: "40", desc: "Freshness in a can."
        [res, food].each { |item| @starter_items << item }
    end

    def starter_damage
        ApocalyptoApp::Supply.new name: "Crowbar", type: "damage", value: 60, cost: "600",
            desc: "The Swissarmy knife of the apocalypse. A must have."
        ApocalyptoApp::Supply.new name: "Zippo", type: "damage", value: 30, cost: "300",
            desc: "Caution: Dangerous near flammable objects."
        weapon = ApocalyptoApp::Supply.new name: "Kitchen Knife", type: "damage", value: 15, cost: "150", desc: "Common kitchen tool."
        @starter_items << weapon
    end

    def start
        system("clear")
        puts "Welcome to Apocalypto"
        divider
        puts "It's the end of days. A plague has taken over the world, turning people into vicious, flesh eating zombies. The world as you know it is over. Your job now? Survive."
        new_line
        puts "Enter your name to begin"
        puts "Input [exit] to escape the apocalypse."
        start_input
    end

    def start_input
        input = gets.strip.downcase.capitalize
        if input == "exit"
            exit
        else
            ApocalyptoApp::Player.new(name: input)
            @starter_items.each { |item| player.add_item item }
            list_countries
        end
    end

    def list_countries
        system("clear")
        puts "Choose a country:"
        new_line
        countries.each.with_index(1) do |country, i|
            puts "#{i}. #{country.name} - #{country.difficulty}"
        end
        prompt_area_selection 
    end

    def prompt_area_selection
        divider
        puts "Please enter a number to make your selection."
        escape
        input = get_num_input countries.size
        if input == 0
            exit
        else
            player.country = countries[input - 1]
            countries[input - 1].welcome
        end
    end

    def gameover
        puts "GAME OVER!"
        puts "Input [start] for a new game or any key to escape the apocalypse."

        input = gets.strip.downcase
        input == "start" ? ApocalyptoApp::CLI.new.start : exit
    end

    def gameover_revive
        puts "You've been knocked out!"
        divider
        player.items.each.with_index(1) do |item, i|
            puts "#{i}. +1 Life | #{item.value}HP - #{item.name}"
        end
        new_line
        puts "Enter [revive] to drink potion."
        puts "Input any key for a new game"
        input = gets.strip.downcase
        input == "revive" ? player.drink_revive : ApocalyptoApp::CLI.new.start
    end

    def add_random_drop
        item = random_drop
        ApocalyptoApp::Supply.gain_item_effect item
    end

    def random_drop
        chance = rand(1..10)
        case chance
        when 1, 3, 8
            ApocalyptoApp::Supply.all.select { |item| item[:type] == "health" }.sample
        when 6
            player.items.sample
        when 9
            ApocalyptoApp::Supply.all.sample
        end
    end

    def countries
        ApocalyptoApp::Country.all
    end
end