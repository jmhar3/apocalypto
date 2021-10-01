class ApocalyptoApp::CLI
    include ApocalyptoApp::Utility

    @@all = []

    def initialize
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
        ApocalyptoApp::Supply.new name: "Resurrection Potion", type: "revive", value: 50, cost: "800", desc: "A mystical potion to bring you back from the depths of hell."
        ApocalyptoApp::Supply.new name: "Aerosol Deoderant", type: "health", value: 20, cost: "40", desc: "Freshness in a can."
        ApocalyptoApp::Supply.new name: "Coke", type: "health", value: 15, cost: "30", desc: "Post-apocalyptic fuel."
        ApocalyptoApp::Supply.new name: "Red Bull", type: "health", value: 20, cost: "40", desc: "Gamer fuel."
        ApocalyptoApp::Supply.new name: "Canned Beans", type: "health", value: 30, cost: "60", desc: "Warning: Do not eat in confined space with others."
        ApocalyptoApp::Supply.new name: "Jerky", type: "health", value: 40, cost: "80", desc: "Unknown animal origin."
        ApocalyptoApp::Supply.new name: "SPAM", type: "health", value: 45, cost: "90", desc: "A canned delicacy in this new age."
        ApocalyptoApp::Supply.new name: "Canned Tuna", type: "health", value: 60, cost: "120", desc: "A canned delicacy in this new age."
        ApocalyptoApp::Supply.new name: "Skag BBQ", type: "health", value: 90, cost: "180", desc: "An unrecognisable, disgusting hunk of flesh burnt to a crisp."
    end

    def starter_damage
        ApocalyptoApp::Supply.new name: "Crowbar", type: "damage", value: 60, cost: "600",
            desc: "The Swissarmy knife of the apocalypse. A must have."
        ApocalyptoApp::Supply.new name: "Zippo", type: "damage", value: 30, cost: "300",
            desc: "Caution: Dangerous near flammable objects."
        ApocalyptoApp::Supply.new name: "Kitchen Knife", type: "damage", value: 15, cost: "150", desc: "Common kitchen tool."
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
        total country.infected
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
        if player.health < player.country.zombies.first.damage
            low_health
        else
            battle_ready
        end
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
        input == "shop" ? access_shop : list_countries
    end

    def battle_ready
        player_char
        current_supply
        puts "You're ready for battle, #{player.name}! ALONZEE!"
        fight_shop_exit
    end
    
    def fight_shop_exit
        divider
        puts "Enter [fight] to kill zombies"
        puts "Enter [shop] to peruse the wares."
        escape
        input = gets.strip.downcase
        if input == "fight"
            spawn_zombie
        elsif input == "shop"
            access_shop
        else
            list_countries
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
        new_line
        divider
        puts "Resurrection Potion - +1 Life | 50HP"
        prompt_revive_selection
    end

    def prompt_revive_selection
        new_line
        puts "Enter [revive] to drink potion."
        puts "Input any key for a new game."
        input = gets.strip.downcase
        input == "revive" ? player_revive : ApocalyptoApp::CLI.new.start
    end

    def player_revive
        player.drink_revive
        player_stats
    end

    def total infected
        puts "There are currently #{infected} zombies plaguing the lands."
    end

    def spawn_zombie
        system("clear")
        puts "A wild zombie appears!"
        new_line
        zombie
        puts "Zombie: #{current_zombie.health} health | #{current_zombie.damage} damage"
        divider
        oh_no
        puts "#{player.name}: #{player.health} health | #{player.damage} damage"
        survival_rate ? uh_oh : (puts "Quick! Hit it with your weapon.")
        attack
    end

    def attack
        new_line
        puts "Input [hit] to attack the zombie."
        puts "Input [run] to run away."
        input = gets.strip.downcase
        input == "hit" ? hit : player_stats
    end

    def hit
        system("clear")
        damage = crit_chance
        result = current_zombie.health - damage
        current_zombie.health = (result <= 0 ? 0 : result)
        if current_zombie.health > 0
            survive_zombie damage
            player_hit
        else
            defeat_zombie
        end
    end

    def crit_chance
        case rand(1..30)
        when 3, 8, 9, 21
            (player.damage.to_f * rand(1.4..1.8)).to_i
        else
            player.damage
        end
    end

    def defeat_zombie
        player.money += current_zombie.money
        add_random_drop
        new_line
        dead_zombie
        puts "You defeated the zombie and gained $#{current_zombie.money}!"
        current_zombie.class.all.delete_if { |z| z == current_zombie }
        fight_shop_exit
    end

    def survive_zombie damage
        result = player.health - current_zombie.damage
        player.health = (result <= 0 ? 0 : result)
        hit_zombie
        puts "Zombie took #{damage} damage. #{current_zombie.health} health remaining."
        puts "Zombie used bite. It was very effective."
        divider
        player.health == 0 ? dazed : ouch
    end

    def player_hit
        if player.health > 0
            puts "You took #{current_zombie.damage} damage. #{player.health} health remaining."
            uh_oh if survival_rate
            attack
        else
            if player.revive.size == 0
                gameover
            else
                gameover_revive
            end
        end
    end

    def survival_rate
        player.health < current_zombie.damage && current_zombie.health > player.damage
    end

    def add_random_drop
        item = random_drop
        ApocalyptoApp::Supply.gain_item_effect item if item != nil
    end

    def random_drop
        case rand(1..30)
        when 1, 3, 8, 21, 30
            all_supplies.filter{ |item| item.type == "health" }.sample
        when 9
            all_supplies.sample
        end
    end

    def access_shop
        system("clear")
        puts "Ye Olde Wares"
        new_line
        puts "Stock up on the finest of wares or sell your goods to make some extra gold"
        divider
        access_shop_input
    end

    def access_shop_input
        puts "Enter [buy] or [sell] to access the store."
        prepare_for_battle
        input = gets.strip.downcase
        if input == "buy"
            buy_items
        elsif input == "sell"
            sell_items
        else
            player_stats
        end
    end

    def sell_items
        system("clear")
        market = "sell"
        puts "Care to sell your wares?"
        stock_inventory player.items, market
        prompt_item_selection(player.items, market)
    end

    def buy_items 
        system("clear")
        market = "buy"
        puts "Stock up on supplies:"
        stock_inventory all_supplies, market
        wallet
        prompt_item_selection(all_supplies, market)
    end
    
    def stock_inventory items, market
        new_line
        items.each.with_index(1) do |item, i|
            puts "#{i}. $"+(market == "buy" ? "#{item.cost}" : "#{sale_price item.cost}")+" - #{item.name}"
        end
        divider
    end

    def prompt_item_selection items, market
        puts "Enter a number to learn more."
        puts "Input any key to prepare for battle."
        input = get_num_input(items.size)
        input == 0 ? player_stats : view_item(items[input - 1], market)
    end

    def view_item item, market
        system("clear")
        puts "#{item.desc}"
        new_line
        item.type == "damage" ? (puts "( -_-)︻╦̵̵͇̿̿̿̿══╤─") : (puts "( -_-)旦~")
        new_line
        puts "#{item.name}"
        if market == "buy"
            puts (item.type == "revive" ? ("+1 Life, #{item.value}HP") : ("+#{item.value} #{item.type}"))+" | $#{item.cost}"
        else
            puts (item.type == "revive" ? ("-1 Life, #{item.value}HP") : ("-#{item.value} #{item.type}"))+" | $#{sale_price item.cost}"
        end
        view_item_prompt item, market
    end

    def view_item_prompt item, market
        divider
        wallet
        if market == "buy"
            player.money >= item.cost ? sufficient_funds(item) : insufficient_funds
        else
            sell item
        end
    end

    def sale_price cost
        (cost.to_f * 0.8).to_i
    end

    def sell item
        puts "Enter [sell] to sell #{item.name}"
        puts "Input any key to return to shop"
        input = gets.strip.downcase
        input == "sell" ? successful_sale(item) : access_shop
    end

    def successful_sale item
        sale_item_effect item
        system("clear")
        puts "You have succesfully sold #{processed_item_name item.name} for #{sale_price item.cost}."
        current_supply
        fight_shop_exit
    end

    def sale_item_effect item
        player.remove_item item
        player.damage -= item.value if item.type == "damage"
        player.money += sale_price item.cost
    end

    def sufficient_funds item
        puts "Enter [buy] to purchase #{item.name}"
        puts "Input any key to return to shop"
        input = gets.strip.downcase
        input == "buy" ? successful_purchase(item) : access_shop
    end

    def insufficient_funds
        puts "You don't have enough money."
        puts "Kill zombies to earn money or find something cheaper."
        fight_shop_exit
    end

    def successful_purchase item
        system("clear")
        gain_item_effect item
        player.money -= item.cost
        current_supply
        fight_shop_exit
    end

    def gain_item_effect item
        player.add_item item
        puts "Congratulation! You are the proud new owner of #{ApocalyptoApp::Supply.processed_item_name item.name}."
    end

    def processed_item_name item
        %w(a e i o u h).include?(item[0].downcase) ? "an #{item.titleize}" : "a #{item.titleize}"
    end
end