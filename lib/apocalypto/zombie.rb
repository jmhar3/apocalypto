class ApocalyptoApp::Zombie
    include ApocalyptoApp::Utility

    attr_accessor :health, :damage, :money, :country

    @@all = []
    
    def initialize id:, health: 30, damage: 5, money: 30
        @id = id
        @health = health
        @damage = damage
        @money = money
        @@all << self
    end

    def self.all
        @@all
    end

    def self.generate_zombies country
        country.infected.split(",").join.to_i.times do |i|
            zombie = zombie_by_difficulty(i, country.difficulty)
            zombie.country = country
        end
    end

    def self.zombie_by_difficulty i, difficulty
        case difficulty
        when "childs play"
            self.new(id: i, health: rand(30..50), damage: rand(5..10), money: rand(30..50))
        when "easy"
            self.new(id: i, health: rand(50..100), damage: rand(20..40), money: rand(50..150))
        when "medium"
            self.new(id: i, health: rand(100..300), damage: rand(40..80), money: rand(150..500))
        when "hard"
            self.new(id: i, health: rand(300..1000), damage: rand(80..160), money: rand(500..1000))
        when "extreme"
            self.new(id: i, health: rand(1000..2500), damage: rand(160..320), money: rand(1000..3000))
        end
    end
end