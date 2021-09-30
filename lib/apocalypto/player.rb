class ApocalyptoApp::Player
    include ApocalyptoApp

    attr_accessor :name, :health, :money, :damage, :revive

    @@all = []

    def initialize name:, health: 50, money: 1000, damage: 9
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
        system("clear")
        if @health < 30
            oh_no
            puts "Uh oh - looks like you're low on health."
            current_supply
            new_line
            divider
            puts "Input [shop] to stock up."
            escape
            input = gets.strip.downcase
            input == "shop" ? ApocalyptoApp::Supply.access_shop : exit
        else
            current_supply
            puts "You're ready for battle, #{self.name}! ALONZEE!"
            divider
            new_line
            puts "Input [fight] to start a battle."
            puts "Input [shop] to gear up"
            escape
            input = gets.strip.downcase
            if input == "fight"
                ApocalyptoApp::Zombie.spawn_zombie
            elsif input == "shop"
                ApocalyptoApp::Supply.access_shop
            else
                exit
            end
        end
    end

    def drink_revive

    end

    def current_supply
        puts "You currently have #{self.health} health, do #{self.damage} damage and have $#{self.money}."
    end
end