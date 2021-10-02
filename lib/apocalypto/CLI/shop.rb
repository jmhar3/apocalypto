class ApocalyptoApp::Shop
    extend ApocalyptoApp::Utility

    def self.access_shop
        system("clear")
        puts "Ye Olde Wares"
        new_line
        puts "Stock up on the finest of wares or sell your goods to make some extra gold"
        divider
        access_shop_input
    end

    def self.access_shop_input
        puts "Enter [buy] or [sell] to access the store."
        prepare_for_battle
        input = gets.strip.downcase
        case input
        when "buy"
            buy_items
        when "sell"
            sell_items
        else
            current_game.player_stats
        end
    end

    def self.buy_items 
        system("clear")
        market = "buy"
        puts "Stock up on supplies:"
        stock_inventory all_supplies, market
        wallet
        prompt_item_selection(all_supplies, market)
    end

    def self.sell_items
        system("clear")
        market = "sell"
        puts "Care to sell your wares?"
        stock_inventory player.items, market
        prompt_item_selection(player.items, market)
    end
    
    def self.stock_inventory items, market
        new_line
        items.each.with_index(1) do |item, i|
            puts "#{i}. $#{price(item, market)} - #{item.name}"
        end
        divider
    end

    def self.prompt_item_selection items, market
        puts "Enter a number to learn more."
        puts "Input any key to prepare for battle."
        input = current_game.get_num_input(items.size)
        input == 0 ? current_game.player_stats : view_item(items[input - 1], market)
    end

    def self.view_item item, market
        system("clear")
        puts "#{item.desc}"
        new_line
        item.type == "damage" ? (puts "( -_-)︻╦̵̵͇̿̿̿̿══╤─") : (puts "( -_-)旦~")
        new_line
        puts "#{item.name}"
        puts "$#{price(item, market)} - #{item_listing(item, market)}"
        view_item_prompt item, market
    end

    def self.price item, market
        sale_price = (item.cost.to_f * 0.8).to_i
        market == "buy" ? item.cost : sale_price
    end

    def self.item_listing item, market
        if market == "buy"
            (item.type == "revive" ? ("+1 Life, #{item.value}HP") : ("+#{item.value} #{item.type}"))
        else
            (item.type == "revive" ? ("-1 Life, #{item.value}HP") : ("-#{item.value} #{item.type}"))
        end
    end

    def self.view_item_prompt item, market
        divider
        wallet
        if market == "buy"
            player.money >= item.cost ? sell_buy(item, market) : insufficient_funds
        else
            sell_buy(item, market)
        end
    end

    def self.sale_item_effect item
        player.remove_item item
        player.damage -= item.value if item.type == "damage"
        player.money += price(item, "sell")
    end

    def self.sell_buy item, market
        puts "Enter [#{market}] to purchase #{item.name}"
        puts "Input any key to return to shop"
        input = gets.strip.downcase
        input == market ? (market == "buy" ? successful_purchase(item) : successful_sale(item)) : access_shop
    end

    def self.insufficient_funds
        puts "You don't have enough money."
        puts "Kill zombies to earn money or find something cheaper."
        current_game.fight_shop_exit
    end

    def self.successful_sale item
        sale_item_effect item
        system("clear")
        puts "You have succesfully sold #{processed_item_name item.name} for #{price(item, "sell")}."
        current_supply
        current_game.fight_shop_exit
    end

    def self.successful_purchase item
        system("clear")
        gain_item_effect item
        player.money -= item.cost
        current_supply
        current_game.fight_shop_exit
    end

    def self.gain_item_effect item
        player.add_item item
        puts "Congratulation! You are the proud new owner of #{processed_item_name item.name}."
    end

    def self.processed_item_name item
        %w(a e i o u h).include?(item[0].downcase) ? "an #{item.titleize}" : "a #{item.titleize}"
    end
end