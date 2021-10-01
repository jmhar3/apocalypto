class ApocalyptoApp::Zombie
    extend ApocalyptoApp::Utility

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
            zombie = zombie_by_difficulty(i, difficulty)
            zombie.country = country
        end
    end

    def self.zombie_by_difficulty i, difficulty
        ten = ((i % 10) == 0)
        case difficulty
        when "childs play"
            ten ? self.new(id: i, health: 50, damage: 10, money: 50) : self.new(id: i)
        when "easy"
            ten ? self.new(id: i, health: 100, damage: 40, money: 150) : self.new(id: i, health: 50, damage: 20, money: 50)
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

    def self.spawn_zombie
        system("clear")
        puts "A wild zombie appears!"
        new_line
        zombie
        puts "Zombie: #{all[-1].health} health | #{all[-1].damage} damage"
        divider
        oh_no
        puts "#{player.name}: #{player.health} health | #{player.damage} damage"
        new_line
        puts "Quick! Hit it with your weapon."
        attack
    end

    def self.hit
        system("clear")
        zombie_damage
        if all[-1].health > 0
            survive_zombie
            if player.health > 0
                puts "You took #{all[-1].damage} damage. #{player.health} health remaining."
                uh_oh if player.health < all[-1].damage && all[-1].health > player.damage
                attack
            else
                if player.revive == 0
                    gameover
                else
                    gameover_revive
                end
            end
        else
            defeat_zombie
        end
    end

    def self.zombie_damage
        damaged = all[-1].health - player.damage
        all[-1].health = (damaged < 0 ? 0 : damaged)
    end

    def self.defeat_zombie
        player.money += all[-1].money
        all.pop
        # REMOVE 1 INFECTED FROM COUNTRY
        dead_zombie
        puts "Congrats! You defeated the zombie and gained $#{all[-1].money}."
        fight_shop_exit
    end

    def self.survive_zombie
        damage = player.health - all[-1].damage
        player.health = (damage < 0 ? 0 : damage)
        hit_zombie
        puts "Zombie took #{player.damage} damage. #{all[-1].health} health remaining."
        puts "Zombie used bite. It was very effective."
        divider
        player.health == 0 ? dazed : ouch
    end

    def self.gameover
        dazed
        puts "GAME OVER!"
        puts "Input [start] for a new game."
        escape

        input = gets.strip.downcase
        input == "start" ? ApocalyptoApp::CLI.new.start : exit
    end

    def self.gameover_revive
        dazed
        puts "You've been knocked out!"
        divider
        player.items.each.with_index(1) do |item, i|
            puts "#{i}. +1 Life | #{item.value}HP - #{item.name}"
        end
        new_line
        puts "Enter [revive] to drink potion."
        puts "Input any key for a new game"
        input = gets.strip.downcase
        input == "revive" ? player.drink_revive : ApocalyptoApp::CLI.new.start
    end

    def self.attack
        new_line
        puts "Input [hit] to attack the zombie."
        puts "Input [run] to run away."
        input = gets.strip.downcase
        input == "hit" ? hit : player.player_stats
    end

    def self.player
        ApocalyptoApp::Player.all[-1]
    end
end