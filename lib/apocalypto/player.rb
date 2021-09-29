class ApocalyptoApp::Player
    include ApocalyptoApp
    attr_accessor :name, :health, :money, :food, :weapons

    @@all = []

    def initialize name:, health: 30, money: 1000
        @name = name
        @health = health
        @money = money
        @food = []
        @weapons = []

        @@all << self
    end

    def self.all
        @@all
    end

    def purchase_item item
        item.type == "food" ? @food << item : @weapons << item
    end
end