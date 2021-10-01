class ApocalyptoApp::Supply
    extend ApocalyptoApp::Utility
    attr_accessor :name, :type, :value, :cost, :desc
    @@all = []

    def initialize name:, type:, value:, cost:, desc:
        @name = name.downcase.titleize
        @type = type
        @value = value.to_i
        @cost = cost.to_i
        @desc = desc
        @@all << self
    end

    def self.sale_price item
        (item.to_f * 0.8).to_i
    end

    def self.all
        @@all.sort_by!(&:type)
    end

    def self.access_shop
        system("clear")
        puts "Ye Olde Wares"
        new_line
        puts "Stock up on the finest wares or sell your goods to make some extra gold"
        divider
        access_shop_input
    end

    def self.access_shop_input
        puts "Enter [buy] or [sell] to access the store."
        prepare_for_battle
        input = gets.strip.downcase
        if input == "buy"
            buy_items
        elsif input == "sell"
            self.sell_items
        else
            player.player_stats
        end
    end

    def self.sell_items
        system("clear")
        puts "Care to sell your wares?"
        stock_inventory player.items, "sell"
        prompt_item_selection(player.items, "sell")
    end

    def self.buy_items 
        system("clear")
        puts "Stock up on supplies:"
        stock_inventory all, "buy"
        player.wallet
        prompt_item_selection(all, "buy")
    end
    
    def self.stock_inventory items, market
        new_line
        items.each.with_index(1) do |item, i|
            puts "#{i}. $"+(market == "buy" ? "#{item.cost}" : "#{sale_price item.cost}")+" - #{item.name}"
        end
        divider
    end

    def self.prompt_item_selection item, market
        puts "Enter a number to learn more."
        puts "Input any key to prepare for battle."
        input = get_num_input(item.size)
        input == 0 ? player.player_stats : view_item(item[input - 1], market)
    end

    def self.view_item item, market
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

    def self.view_item_prompt item, market
        divider
        player.wallet
        if market == "buy"
            player.money >= item.cost ? sufficient_funds(item) : insufficient_funds
        else
            sell item
        end
    end

    def self.sell item
        puts "Enter [sell] to sell #{item.name}"
        puts "Input any key to return to shop"
        input = gets.strip.downcase
        input == "sell" ? successful_sale(item) : access_shop
    end

    def self.successful_sale item
        sale_item_effect item
        system("clear")
        puts "You have succesfully sold #{processed_item_name item.name} for #{sale_price item.cost}."
        player.current_supply
        fight_shop_exit
    end

    def self.sale_item_effect item
        player.remove_item item
        if item.type == "damage"
            player.damage -= item.value
        elsif item.type == "health"
            player.health -= item.value
        end
        player.money += sale_price item.cost
    end

    def self.sufficient_funds item
        puts "Enter [buy] to purchase #{item.name}"
        puts "Input any key to return to shop"
        input = gets.strip.downcase
        input == "buy" ? successful_purchase(item) : access_shop
    end

    def self.insufficient_funds
        puts "You don't have enough money."
        puts "Kill zombies to earn money or find something cheaper."
        fight_shop_exit
    end

    def self.successful_purchase item
        system("clear")
        gain_item_effect item
        player.money -= item.cost
        player.current_supply
        fight_shop_exit
    end

    def self.gain_item_effect item
        player.add_item item
        puts "Congratulation! You are the proud new owner of #{ApocalyptoApp::Supply.processed_item_name item.name}."
    end

    def self.processed_item_name item
        %w(a e i o u h).include?(item[0].downcase) ? "an #{item.titleize}" : "a #{item.titleize}"
    end
end