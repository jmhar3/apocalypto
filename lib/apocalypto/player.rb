class ApocalyptoApp::Player
    include ApocalyptoApp
    attr_accessor :name, :health, :money, :food, :weapons

    @@all = []

    def initialize name:, health: 30, money: 1000
        @name = name
        @health = health
        @money = money
        @food = ["apple"]
        @weapons = ["stick"]

        @@all << self
    end

    def self.all
        @@all
    end

    def player_stats
        if @food.size < 3 || @weapons.size < 1
            puts "Uh oh - looks like you're low on supplies."
            current_supply
            puts "Input [shop] to stock up."
            exit
            input = gets.strip.downcase
            # input == "shop" ? ApocalyptoApp::Shop.access_shop : exit
        elsif
            current_supply
            puts "You're ready for battle, #{self.name}! ALONZEE"
            puts "Input [fight] to start a battle."
            exit
            input = gets.strip.downcase
            # input == "fight" ? ApocalyptoApp::Zombie.spawn_zombie : exit
        end
    end

    def current_supply
        puts "You currently have #{self.food.size} food and #{self.weapons.size} damage."
    end

    def purchase_item item
        item.type == "food" ? @food << item : @weapons << item
    end
end