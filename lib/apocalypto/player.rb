class ApocalyptoApp::Player
    include ApocalyptoApp::Utility

    attr_accessor :name, :health, :money, :damage, :revive

    @@all = []

    def initialize name:, health: 50, money: 500, damage: 9, revive: 1
        @name = name
        @health = health
        @damage = damage
        @money = money
        @revive = revive
        @items = []

        @@all << self
    end

    def self.all
        @@all
    end
  
    def add_item item
      @items << item
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
        uh_oh
        current_supply
        divider
        puts "Input [shop] to stock up."
        escape
        input = gets.strip.downcase
        input == "shop" ? ApocalyptoApp::Supply.access_shop : exit
    end

    def battle_ready
        player_char
        current_supply
        puts "You're ready for battle, #{self.name}! ALONZEE!"
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

    def wallet
        puts "You currently have $#{self.money}."
    end
end