class ApocalyptoApp::Player
    include ApocalyptoApp

    attr_accessor :name, :health, :money, :food, :weapons

    def initialize name:, health: 30, money: 1000, food:, weapons:
        @name = name
        @health = health
        @money = money
        @food = [food]
        @weapons = [weapons]
    end
end