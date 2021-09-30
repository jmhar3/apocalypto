class ApocalyptoApp::Zombie
    include ApocalyptoApp

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

    def self.generate_zombies infected, difficulty, country
        infected.times do |i|
            ten = ((i % 10) == 0)
            zombie = zombie_by_difficulty i, ten, difficulty
            country.add_zombie zombie
        end
    end

    def self.zombie_by_difficulty i, ten, difficulty
        case difficulty
        when "childsplay"
            ten ? self.new(id: i, health: 50, damage: 10, money: 50) : self.new(id: i)
        when "easy"
            ten ? self.new(id: i, health: 100, damage: 30, money: 150) : self.new(id: i, health: 50, damage: 10, money: 50)
        when "medium"
            ten ? self.new(id: i, health: 300, damage: 30, money: 500) : self.new(id: i, health: 100, damage: 30, money: 150)
        when "hard"
            ten ? self.new(id: i, health: 1000, damage: 100, money: 1000) : self.new(id: i, health: 300, damage: 30, money: 500)
        when "extreme"
            ten ? self.new(id: i, health: 2500, damage: 300, money: 3000) : self.new(id: i, health: 1000, damage: 100, money: 1000)
        end
    end

    def self.total infected
        puts "There are currently #{infected} zombies plaguing the lands."
    end

    def self.spawn_zombie
        system("clear")
        puts "A wild zombie appears!"
        # divider
        # new_line
        # zombie
        puts "Zombie: #{all[-1].health} health | #{all[-1].damage} damage"
        puts "Quick! Hit it with your weapon."
        # divider
        # new_line
        puts "#{player.name}: #{player.health} health | #{player.damage} damage"
        attack
    end

    def self.hit
        system("clear")
        zombie_damage
        if all[-1].health <= 0
            defeat_zombie
        else
            survive_zombie
            if player.health > 0
                puts "You have #{player.health} health left."
                # new_line
                attack
            elsif player.revive == 0
                gameover
            else
                gameover_revive
            end
        end
    end

    def self.zombie_damage
        damage = all[-1].health - player.damage
        all[-1].health = (damage < 0 ? 0 : damage)
    end

    def self.defeat_zombie
        player.money += all[-1].money
        all.pop
        # REMOVE 1 INFECTED FROM COUNTRY
        # dead_zombie
        puts "Congrats! You defeated the zombie."
        # divider
        # new_line
        puts "Want to keep fighting?"
        puts "Input [y] to continue."
        input = gets.strip.downcase
        input == "y" ? player.player_stats : exit
    end

    def self.survive_zombie
        player.health -= all[-1].damage
        # hit_zombie
        puts "Zombie took #{player.damage} damage. #{all[-1].health} health remaining."
        # divider
        # new_line
        # hit
        puts "Zombie used bite. It was very effective."
    end

    def self.gameover
        # dazed
        puts "GAME OVER!"
        puts "Input [start] for a new game."
        # escape

        input = gets.strip.downcase
        input == "start" ? ApocalyptoApp::CLI.new.start : exit
    end

    def self.gameover_revive
        # dazed
        puts "You've been knocked out!"
        puts "Enter [revive] to drink potion."
        puts "Input any key for a new game"
                
        input = gets.strip.downcase
        input == "revive" ? player.drink_revive : ApocalyptoApp::CLI.new.start
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