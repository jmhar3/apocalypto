class ApocalyptoApp::Supply
    attr_accessor :name, :type, :value

    @@all = []

    def initialize name:, type:, value:
        @name = name
        @type = type
        @value = value
        @@all << self
    end

    def self.all
        @@all
    end

    def self.access_shop
        system("clear")
        puts "Stock up on supplies:"
        new_line
        divider
        all.each.with_index(1) do |supply, i|
            puts "#{i}. #{supply.name} +#{supply.value} #{supply.type} - $#{supply.value}"
        end
        prompt_area_selection
    end

    def self.prompt_area_selection
        divider
        new_line
        puts "Please enter a number to purchase an item."
        escape

        input = get_user_input
        input == 0 ? exit : purchase_item all[input - 1]
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
        if player.money > item.value
            item.type == "food" ? player.health += item.value : self.damage += item.value
            self.money -= item.value
            puts "Congratulation! You are the proud new owner of #{item.name}"
            player.current_supply
        else
            puts "You don't have enough money."
            puts "Enter [fight] to kill more zombies or [shop] to find something cheaper."
            escape
            input = gets.strip.downcase
            if input == "fight"
                ApocalyptoApp::Zombie.spawn_zombie
            elsif input == "shop"
                ApocalyptoApp::Shop.access_shop
            else
                exit
            end
        end
    end

    def self.player
        ApocalyptoApp::Player.all[-1]
    end
end