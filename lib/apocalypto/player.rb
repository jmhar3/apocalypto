class ApocalyptoApp::Player
    include ApocalyptoApp::Utility
    attr_accessor :name, :health, :money, :damage, :items, :country

    @@all = []

    def initialize name:, health: 50, money: 500, damage: 10
        @name = name
        @health = health
        @damage = damage
        @money = money
        @items = []
        @@all << self
    end

    def self.all
        @@all
    end
  
    def add_item item
        if item.type == "damage"
            self.damage += item.value
            @items << item
        elsif item.type == "health"
            self.health += item.value
        else
            @items << item
        end
    end

    def remove_item item
        @items.delete_if { |i| i == item }
    end

    def revive
        @items.select { |item| item.type == "revive" }
    end

    def drink_revive
        @items.delete_at(self.items.index { |item| item.type == "revive" } || self.items.length)
        @health = 50
    end
end