class ApocalyptoApp::Player
    include ApocalyptoApp
    extend ApocalyptoApp

    attr_accessor :name, :health, :money, :damage, :revive

    @@all = []

    def initialize name:, health: 50, money: 1000, damage: 9, revive: 1
        @name = name
        @health = health
        @damage = damage
        @money = money
        @revive = revive

        @@all << self
    end

    def self.all
        @@all
    end

    def player_stats
        system("clear")
        if @health < 30
            low_health
        else
            battle_ready
        end
    end

    def low_health
        oh_no
        puts "Uh oh - looks like you're low on health."
        current_supply
        new_line
        divider
        puts "Input [shop] to stock up."
        escape
        input = gets.strip.downcase
        input == "shop" ? ApocalyptoApp::Supply.access_shop : exit
    end

    def battle_ready
        player_char
        new_line
        current_supply
        puts "You're ready for battle, #{self.name}! ALONZEE!"
        new_line
        divider
        new_line
        puts "Input [fight] to start a battle."
        puts "Input [shop] to gear up"
        fight_shop_exit
    end

    def drink_revive
        @revive -= 1
        @health = 50
        player_stats
    end

    def current_supply
        puts "You currently have #{self.health} health, do #{self.damage} damage and have $#{self.money}."
    end
end