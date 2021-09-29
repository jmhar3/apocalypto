class ApocalyptoApp::Zombie
    include ApocalyptoApp

    attr_accessor :health, :damage, :money

    @@all = []
    
    def initialize id:, health: 25, damage: 10, money: 30
        @id = id
        @health = health
        @damage = damage
        @money = money
        @@all << self
    end

    def self.all
        @@all
    end

    def self.generate_zombies infected
        infected.times do |i|
            if ((i % 10) == 0)
                self.new id: i, health: 60, damage: 10, money: 100
            # elsif (i = 1)
            #     self.new id: i, health: 500, damage: 30, money: 1000
            else
                self.new id: i
            end
        end
    end

    def self.total infected
        puts "There are currently #{infected} zombies plaguing the lands."
    end

    def self.spawn_zombie
        system("clear")
        # zombie
        puts "#{all[all.size - 1].health} health | #{all[all.size - 1].damage} damage"
        puts "A wild zombie appears!"
        puts "Quick! Hit it with your weapon."
        # divider
        # new_line
        puts "#{player.health} health | #{player.damage} damage"
        attack
    end

    def self.hit
        system("clear")
        all[-1].health -= player.damage
        if all[-1].health <= 0
            player.money += all[-1].money
            all.pop
            # dead_zombie
            puts "Congrats! You defeated the zombie."
            # divider
            # new_line
            puts "Want to keep fighting?"
            puts "Input [y] to continue."
            input = gets.strip.downcase
            input == "y" ? player.player_stats : exit
        else
            player.health -= all[-1].damage
            # hit_zombie
            puts "Zombie took #{player.damage} damage. #{all[-1].health} health remaining."
            # divider
            # new_line
            # hit
            puts "Zombie used bite. It was very effective."
            if player.health > 0
                puts "You have #{player.health} health left."
                # new_line
                attack
            else
                puts "GAME OVER!"
                puts "Input [start] for a new game."
                # escape

                input = gets.strip.downcase
                input == "start" ? ApocalyptoApp::CLI.new.start : exit
            end
        end
    end

    def self.attack
        puts "Input [hit] to attack the zombie."
        puts "Input [run] to run away."
        input = gets.strip.downcase
        input == "hit" ? hit : player.player_stats
    end

    def self.player
        ApocalyptoApp::Player.all[-1]
    end
end