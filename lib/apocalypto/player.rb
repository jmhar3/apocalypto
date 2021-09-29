class ApocalyptoApp::Player
    include ApocalyptoApp

    attr_accessor :name, :health, :money, :food, :weapons

    def initialize name:, health: 30, money: 1000
        @name = name
        @health = health
        @money = money
        @food = []
        @weapons = []
    end

    def purchase_item item
        item.type == "food" ? @food << item : @weapons << item
    end
end