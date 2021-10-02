module ApocalyptoApp::Utility
    def player
        ApocalyptoApp::Player.all[-1]
    end

    def current_game
        ApocalyptoApp::CLI.all[-1]
    end

    def all_supplies
        ApocalyptoApp::Supply.all
    end

    def countries
        ApocalyptoApp::Country.all
    end

    def current_zombie
        player.country.zombies.first
    end

    def escape
        puts "Enter any key to choose a new area."
    end

    def prepare_for_battle
        puts "Enter any key to prepare for battle."
    end

    def uh_oh
        new_line
        puts "Uh oh - looks like you're low on health."
    end

    def current_supply
        puts "You currently have #{player.health} health, do #{player.damage} damage and have $#{player.money}."
    end

    def wallet
        puts "You currently have $#{player.money}."
    end
    
    def new_line
        puts ""
    end

    def divider
        puts "═════════ ∘◦ ❈ ◦∘ ═════════"
        new_line
    end

    def zombie
        puts "‿︵‿︵(ಥ﹏ಥ)‿︵‿︵"
        new_line
    end

    def hit_zombie
        puts "‿︵‿︵(ಥ﹏☆)‿︵‿︵"
        new_line
    end

    def dead_zombie
        puts "‿︵‿︵(☆﹏☆)‿︵‿︵"
        new_line
    end

    def player_char
        puts "(・̆‿・̆)"
        new_line
    end

    def oh_no
        puts "ᵒʰ(⑉・̆⌓・̆⑉)ɴᴏ"
        new_line
    end

    def dazed
        puts "(⑉☆｡☆⑉)"
        new_line
    end

    def ouch
        puts "(ﾉ>｡☆)ﾉ"
        new_line
    end
end