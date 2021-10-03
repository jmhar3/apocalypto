class ApocalyptoApp::Country
    attr_accessor :name, :infected
    @@all = []

    def initialize name:, infected: 0
        @name = name
        @infected = infected
        @@all << self unless name == "" || name == "^^[1]testing capacity^^" || name == "UTC"
    end
    
    def self.all
        @@all
    end

    def zombies
        ApocalyptoApp::Zombie.all.filter do |zombie|
            zombie.country == self
        end
    end

    def difficulty
        i = @infected.split(",").join.to_i
        if i > 100000
            "extreme"
        elsif i < 100000 && i > 50000
            "hard"
        elsif i < 50000 && i > 10000
            "medium"
        elsif i < 10000 && i > 100
            "easy"
        elsif i < 100
            "childs play"
        end
    end
end