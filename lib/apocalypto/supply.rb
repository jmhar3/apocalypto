class ApocalyptoApp::Supply
    extend ApocalyptoApp
    attr_accessor :name, :type, :value, :cost

    @@all = []

    def initialize name:, type:, value:, cost:
        @name = name
        @type = type
        @value = value.to_i
        @cost = cost.to_i
        @@all << self
    end

    def self.all
        @@all.sort_by!(&:type)
    end

    def self.access_shop
        system("clear")
        puts "Stock up on supplies:"
        divider
        new_line
        all.each.with_index(1) do |supply, i|
            if supply.type == "revive"
                puts "#{i}. $#{supply.cost} - #{supply.name} | +1 Life - #{supply.value}HP"
            else
                puts "#{i}. $#{supply.cost} - #{supply.name} | +#{supply.value} #{supply.type}"
            end
        end
        prompt_area_selection
    end

    def self.prompt_area_selection
        divider
        new_line
        puts "Enter a number to purchase an item."
        escape

        input = get_user_input
        input == 0 ? exit : purchase_item(all[input - 1])
    end

    def self.get_user_input
        input = gets.strip.to_i
        if input > all.size
            puts "Invalid selection: No item exists."
            puts "Please input a valid number."
            return get_user_input
        end
        input
    end

    def self.purchase_item item
        system("clear")
        if player.money >= item.cost
            sufficient_funds item
        else
            insufficient_funds
        end
        fight_shop_exit
    end

    def self.sufficient_funds item
        if item.type == "revive"
            player.revive += 1
        elsif item.type == "health"
            player.health += item.value
        else
            player.damage += item.value
        end
        player.money -= item.cost
        puts "Congratulation! You are the proud new owner of #{purchased_item_name item.name}."
        player.current_supply
        new_line
        puts "Enter [fight] to kill more zombies or [shop] to keep browsing."
    end

    def self.insufficient_funds
        puts "You don't have enough money."
        puts "Enter [fight] to kill more zombies or [shop] to find something cheaper."
    end

    def self.purchased_item_name item
        %w(a e i o u h).include?(item[0].downcase) ? "an #{item.titleize}" : "a #{item.titleize}"
    end


    def self.player
        ApocalyptoApp::Player.all[-1]
    end
end