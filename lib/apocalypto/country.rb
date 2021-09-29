class ApocalyptoApp::Country
    include ApocalyptoApp
    attr_accessor :name, :infected
    @@all = []

    def initialize name:, infected: 0
        @name = name
        @infected = infected
        if name == "" || name == "^^[1]testing capacity^^" || name == "UTC"
        else
            @@all << self
        end
    end

    def self.all
        @@all
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

    def welcome
        ApocalyptoApp::Zombie.generate_zombies infected.split(",").join.to_i
        system("clear")
        puts "Welcome, #{ApocalyptoApp::Player.all[-1].name}, to the distopian future we call #{name}."
        ApocalyptoApp::Zombie.total infected
        divider
        new_line
        puts "It's your task to destroy blah blah blah"
        new_line
        puts "Enter [continue] to prepare for battle."
        puts "Input any key to exit."
        input = gets.strip.downcase
        input == "continue" ?  ApocalyptoApp::Player.all[-1].player_stats : exit
    end

    
end