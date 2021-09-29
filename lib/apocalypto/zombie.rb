class ApocalyptoApp::Zombie
    attr_accessor :health, :damage

    @@all = []
    
    def initialize id:, health: 30, damage: 5
        @id = id
        @health = health
        @damage = damage
        @@all << self
    end

    def self.all
        @@all
    end

    def self.generate_zombies infected
        infected.times do |i|
            if ((i % 10) == 0)
                self.new id: i, health: 60, damage: 10
            elsif (i = 1)
                self.new id: i, health: 500, damage: 30
            else
                self.new id: i
            end
        end
    end

    def self.total infected
        puts "There are currently #{infected} zombies plaguing the lands."
    end

    def self.spawn_zombie
        puts "hello world"
    end
end