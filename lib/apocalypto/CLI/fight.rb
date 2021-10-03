class ApocalyptoApp::Fight
    extend ApocalyptoApp::Utility

    def self.spawn_zombie
        system("clear")
        puts "A wild zombie appears!"
        new_line
        zombie
        puts "Zombie: #{current_zombie.health} health | #{current_zombie.damage} damage"
        divider
        oh_no
        puts "#{player.name}: #{player.health} health | #{player.damage} damage"
        survival_rate ? uh_oh : (puts "Quick! Hit it with your weapon.")
        attack
    end

    def self.attack
        new_line
        puts "Input [hit] to attack the zombie."
        puts "Input [run] to run away."
        input = gets.strip.downcase
        input == "hit" ? hit : current_game.player_stats
    end

    def self.hit
        system("clear")
        damage = crit_chance
        result = current_zombie.health - damage
        current_zombie.health = (result <= 0 ? 0 : result)
        if current_zombie.health > 0
            survive_zombie damage
            player_hit
        else
            defeat_zombie
        end
    end

    def self.crit_chance
        rand(1..30) =~ /^(3|8|9|21)$/ ? (player.damage.to_f * rand(1.4..1.8)).to_i : player.damage
    end

    def self.defeat_zombie
        player.money += current_zombie.money
        current_zombie.class.all.delete_if { |z| z == current_zombie }
        add_random_drop
        new_line
        dead_zombie
        puts "You defeated the zombie and gained $#{current_zombie.money}!"
        current_game.fight_shop_exit
    end

    def self.add_random_drop
        item = random_drop
        gain_item_effect item if item != nil
    end

    def self.random_drop
        case rand(1..30)
        when 1, 3, 8, 21, 30
            all_supplies.filter{ |item| item.type == "health" }.sample
        when 9
            all_supplies.sample
        end
    end

    def self.survive_zombie damage
        result = player.health - current_zombie.damage
        player.health = (result <= 0 ? 0 : result)
        hit_zombie
        puts "Zombie took #{damage} damage. #{current_zombie.health} health remaining."
        puts "Zombie used bite. It was very effective."
        divider
        player.health == 0 ? dazed : ouch
    end

    def self.player_hit
        if player.health > 0
            puts "You took #{current_zombie.damage} damage. #{player.health} health remaining."
            uh_oh if survival_rate
            attack
        else
            player.revive.size == 0 ? gameover : gameover_revive
        end
    end

    def self.survival_rate
        player.health < current_zombie.damage && current_zombie.health > player.damage
    end

    def self.gameover
        puts "GAME OVER!"
        puts "Input [start] for a new game or any key to escape the apocalypse."
        input = gets.strip.downcase
        input == "start" ? ApocalyptoApp::CLI.new.start : exit
    end

    def self.gameover_revive
        puts "You've been knocked out!"
        new_line
        divider
        puts "Resurrection Potion - +1 Life | 50HP"
        prompt_revive_selection
    end

    def self.prompt_revive_selection
        new_line
        puts "Enter [revive] to drink potion."
        puts "Input any key for a new game."
        input = gets.strip.downcase
        input == "revive" ? player_revive : ApocalyptoApp::CLI.new.start
    end

    def self.player_revive
        player.drink_revive
        current_game.player_stats
    end
end