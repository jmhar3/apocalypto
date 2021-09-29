class ApocalyptoApp::Country
    attr_accessor :name, :infected
    @@all = []

    def initialize name:, infected: 0
        @name = name
        @infected = infected.split(",").join.to_i
        if name == "" || name == "^^[1]testing capacity^^" || name == "UTC"
        else
            @@all << self
        end
    end

    def self.all
        @@all
    end

    def difficulty
        i = @infected
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

    def welcome
        ApocalyptoApp::Zombie.generate_zombies infected

        system("clear")
        puts "Welcome #{ApocalyptoApp::Player.all[-1].name} to #{name}."
        # ApocalyptoApp::Zombie.total
    end

    
end