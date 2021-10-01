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
        ten = ((i % 10) == 0 && i != 1)
        case difficulty
        when "childs play"
            ten ? self.new(id: i, health: 50, damage: 10, money: 50) : self.new(id: i)
        when "easy"
            ten ? self.new(id: i, health: 1, damage: 40, money: 150) : self.new(id: i, health: 50, damage: 20, money: 50)
        when "medium"
            ten ? self.new(id: i, health: 300, damage: 80, money: 500) : self.new(id: i, health: 100, damage: 40, money: 150)
        when "hard"
            ten ? self.new(id: i, health: 1000, damage: 160, money: 1000) : self.new(id: i, health: 300, damage: 80, money: 500)
        when "extreme"
            ten ? self.new(id: i, health: 2500, damage: 320, money: 3000) : self.new(id: i, health: 1000, damage: 160, money: 1000)
        end
    end

    def self.total infected
        puts "There are currently #{infected} zombies plaguing the lands."
    end

    def spawn_zombie
        system("clear")
        puts "A wild zombie appears!"
        new_line
        zombie
        puts "Zombie: #{self.health} health | #{self.damage} damage"
        divider
        oh_no
        puts "#{player.name}: #{player.health} health | #{player.damage} damage"
        survival_rate ? uh_oh : (puts "Quick! Hit it with your weapon.")
        attack
    end

    def attack
        new_line
        puts "Input [hit] to attack the zombie."
        puts "Input [run] to run away."
        input = gets.strip.downcase
        input == "hit" ? hit : player.player_stats
    end

    def hit
        system("clear")
        result = self.health - player.damage
        self.health = (result <= 0 ? 0 : result)
        if self.health > 0
            survive_zombie
            player_hit
        else
            defeat_zombie
        end
    end

    def defeat_zombie
        player.money += self.money
        current_game.add_random_drop
        new_line
        dead_zombie
        puts "Congrats! You defeated the zombie and gained $#{self.money}."
        self.class.all.delete_if { |z| z == self }
        fight_shop_exit
    end

    def survive_zombie
        result = player.health - self.damage
        player.health = (result <= 0 ? 0 : result)
        hit_zombie
        puts "Zombie took #{player.damage} damage. #{self.health} health remaining."
        puts "Zombie used bite. It was very effective."
        divider
        player.health == 0 ? dazed : ouch
    end

    def player_hit
        if player.health > 0
            puts "You took #{self.damage} damage. #{player.health} health remaining."
            uh_oh if survival_rate
            attack
        else
            if player.revive.size == 0
                current_game.gameover
            else
                current_game.gameover_revive
            end
        end
    end

    def survival_rate
        player.health < self.damage && self.health > player.damage
    end
end