class ApocalyptoApp::Supply
    extend ApocalyptoApp
    attr_accessor :name, :type, :value, :cost, :desc

    @@all = []

    def initialize name:, type:, value:, cost:, desc:
        @name = name
        @type = type
        @value = value.to_i
        @cost = cost.to_i
        @desc = desc
        @@all << self
    end

    def self.all
        @@all.sort_by!(&:type)
    end

    def self.access_shop
        system("clear")
        puts "Stock up on supplies:"
        new_line
        all.each.with_index(1) do |supply, i|
            puts "#{i}. $#{supply.cost} - #{supply.name}"
        end
        divider
        player.wallet
        prompt_item_selection
    end

    def self.prompt_item_selection
        new_line
        puts "Enter a number to learn more."
        puts "Input any key to prepare for battle"
        input = get_player_input
        input == 0 ? player.player_stats : view_item(all[input - 1])
    end

    def self.get_player_input
        input = gets.strip.to_i
        if input > all.size
            puts "Invalid selection: No item exists."
            puts "Please input a valid number."
            return get_player_input
        end
        input
    end

    def self.view_item item
        system("clear")
        puts "#{item.desc}"
        new_line
        puts "#{item.name}"
        if item.type == "revive"
            puts "+1 Life, #{item.value}HP | $#{item.cost}"
        else
            puts "+#{item.value} #{item.type} | $#{item.cost}"
        end
        divider
        player.wallet
        new_line
        player.money >= item.cost ? sufficient_funds(item) : insufficient_funds
    end

    def self.sufficient_funds item
        puts "Enter [buy] to purchase #{item.name}"
        puts "Input any key to return to shop"
        input = gets.strip.downcase
        input == "buy" ? successful_purchase(item) : access_shop
    end

    def self.insufficient_funds
        puts "You don't have enough money."
        fight_shop_exit
    end

    def self.successful_purchase item
        if item.type == "revive"
            player.revive += 1
        elsif item.type == "health"
            player.health += item.value
        else
            player.damage += item.value
        end
        player.money -= item.cost
        system("clear")
        puts "Congratulation! You are the proud new owner of #{purchased_item_name item.name}."
        player.current_supply
        new_line
        fight_shop_exit
    end

    def self.purchased_item_name item
        %w(a e i o u h).include?(item[0].downcase) ? "an #{item.titleize}" : "a #{item.titleize}"
    end


    def self.player
        ApocalyptoApp::Player.all[-1]
    end
end