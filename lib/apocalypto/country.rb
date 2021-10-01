class ApocalyptoApp::Country
    include ApocalyptoApp::Utility
    
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

    def welcome
        system("clear")
        if infected.split(",").join.to_i == 0
            no_zombie_welcome
        else
            zombie_welcome
        end
    end

    def no_zombie_welcome
        puts "Welcome, #{player.name}, to the oasis we call #{name}."
        puts "Zombies haven't yet reached these lands."
        divider
        puts "Enter [y] to choose another country."
        escape
        input = gets.strip.downcase
        input == "y" ?  current_game.list_countries : exit
    end

    def zombie_welcome
        puts "Welcome, #{player.name}, to the distopian future we call #{name}."
        ApocalyptoApp::Zombie.total infected
        divider
        puts "Society as we know it is in shambles. Fear has taken hold of #{name}. The people are busy hiding, dying or fighting amongst themselves. You alone are left to defend and destroy."
        zombie_welcome_prompt
    end

    def zombie_welcome_prompt
        new_line
        puts "Kill zombies to earn currency so you can gear up in preparation for the super zombies!"
        new_line
        puts "Enter [begin] to prepare for battle."
        escape
        input = gets.strip.downcase
        input == "begin" ?  player.player_stats : current_game.list_countries
    end
end