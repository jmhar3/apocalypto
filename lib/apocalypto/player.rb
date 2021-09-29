class ApocalyptoApp::Player
    include ApocalyptoApp

    attr_accessor :name, :health, :money, :damage

    @@all = []

    def initialize name:, health: 30, money: 1000, damage: 10
        @name = name
        @health = health
        @damage = damage
        @money = money

        @@all << self
    end

    def self.all
        @@all
    end

    def player_stats
        if @health < 10
            oh_no
            puts "Uh oh - looks like you're low on health."
            current_supply
            puts "Input [shop] to stock up."
            escape
            input = gets.strip.downcase
            input == "shop" ? ApocalyptoApp::Shop.access_shop : exit
        elsif
            current_supply
            puts "You're ready for battle, #{self.name}! ALONZEE"
            puts "Input [fight] to start a battle."
            puts "Input [shop] to gear up"
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

    def current_supply
        puts "You currently have #{self.health} health and do #{self.damage} damage."
    end

    # def purchase_item item
    #     item.type == "food" ? @food << item : @weapons << item
    # end
end