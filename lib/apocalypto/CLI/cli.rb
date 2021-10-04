class ApocalyptoApp::CLI
    include ApocalyptoApp::Utility

    @@all = []

    def initialize
        starter_supplies.each {|supply| ApocalyptoApp::Supply.new supply}
        ApocalyptoApp::Scraper.new.get_countries
        ApocalyptoApp::Scraper.new.get_weapons
        @@all << self
    end

    def self.all
        @@all
    end

    def starter_supplies
        [{name: "Resurrection Potion", type: "revive", value: 50, cost: "800", desc: "A mystical potion to bring you back from the depths of hell."}, {name: "Aerosol Deoderant", type: "health", value: 20, cost: "40", desc: "Freshness in a can."}, {name: "Coke", type: "health", value: 15, cost: "30", desc: "Post-apocalyptic fuel."}, {name: "Red Bull", type: "health", value: 20, cost: "40", desc: "Gamer fuel."}, {name: "Canned Beans", type: "health", value: 30, cost: "60", desc: "Warning: Do not consume when trapped in a confined space."}, {name: "Jerky", type: "health", value: 40, cost: "80", desc: "Unknown animal origin."}, {name: "SPAM", type: "health", value: 45, cost: "90", desc: "A canned delicacy in this new age."}, {name: "Canned Tuna", type: "health", value: 60, cost: "120", desc: "A canned delicacy in this new age."}, {name: "Skag BBQ", type: "health", value: 90, cost: "180", desc: "An unrecognisable, disgusting hunk of flesh burnt to a crisp."}, {name: "Crowbar", type: "damage", value: 60, cost: "600", desc: "The Swissarmy knife of the apocalypse. A must have."}, {name: "Zippo", type: "damage", value: 30, cost: "300", desc: "Caution: Dangerous near flammable objects."}, {name: "Kitchen Knife", type: "damage", value: 15, cost: "150", desc: "Common kitchen tool."}]
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
            new_player input
            list_countries
        end
    end

    def new_player input
        ApocalyptoApp::Player.new(name: input)
        starter_items = all_supplies.filter {|item| item.name.downcase =~ /^(resurrection\ potion|red\ bull|kitchen\ knife)$/}
        starter_items.each { |item| player.add_item item }
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
        puts "Input any key to escape the apocalypse."
        input = get_num_input countries.size
        if input == 0
            exit
        else
            player.country = countries[input - 1]
            welcome player.country
        end
    end

    def get_num_input comparison
        input = gets.strip.to_i
        if input > comparison
            puts "Invalid selection. Please input a valid number."
            get_user_input
        end
        input
    end

    def welcome country
        system("clear")
        if country.infected.split(",").join.to_i == 0
            no_zombie_welcome country
        else
            zombie_welcome country
        end
    end

    def no_zombie_welcome country
        puts "Welcome, #{player.name}, to the oasis we call #{country.name}."
        puts "Zombies haven't yet reached these lands."
        divider
        puts "Enter [y] to choose another country."
        escape
        input = gets.strip.downcase
        input == "y" ?  list_countries : exit
    end

    def zombie_welcome country
        puts "Welcome, #{player.name}, to the distopian future we call #{country.name}."
        puts "There are currently #{country.infected} zombies plaguing the lands."
        divider
        puts "Society as we know it is in shambles. Fear has taken hold of #{country.name}. The people are busy hiding, dying or fighting amongst themselves. You alone are left to defend and destroy."
        zombie_welcome_prompt
    end

    def zombie_welcome_prompt
        new_line
        puts "You're armed with nothing but a kitchen knife."
        puts "Kill zombies and gear up in preparation for the super zombies!"
        puts "If you run low on life consume items to heal."
        new_line
        puts "Enter [begin] to prepare for battle."
        escape
        input = gets.strip.downcase
        input == "begin" ?  player_stats : list_countries
    end

    def player_stats
        system("clear")
        player.health < player.country.zombies.first.damage ? :low_health : battle_ready
    end

    def low_health
        oh_no
        uh_oh
        current_supply
        divider
        low_health_input
    end

    def low_health_input
        puts "You can purchase supplies from the store or choose an easier area."
        new_line
        puts "Input [shop] to stock up."
        escape
        input = gets.strip.downcase
        input == "shop" ? ApocalyptoApp::Shop.access_shop : list_countries
    end

    def battle_ready
        player_char
        current_supply
        puts "You're ready for battle, #{player.name}! ALONZEE!"
        fight_shop_exit
    end

    def fight_shop_exit
        divider
        puts "Press [Enter] to kill zombies"
        puts "Enter [shop] to peruse the wares."
        puts "Enter [list] to select a new area."
        input = gets.strip.downcase
        case input
        when "list"
            list_countries
        when "shop"
            ApocalyptoApp::Shop.access_shop
        else
            ApocalyptoApp::Fight.spawn_zombie
        end
    end
end