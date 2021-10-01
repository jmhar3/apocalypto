module ApocalyptoApp::Utility
    def fight_shop_exit
        divider
        puts "Enter [fight] to kill zombies"
        puts "Enter [shop] to peruse the wares."
        escape
        input = gets.strip.downcase
        if input == "fight"
            player.country.zombies.first.spawn_zombie
        elsif input == "shop"
            ApocalyptoApp::Supply.access_shop
        else
            current_game.list_countries
        end
    end

    def get_num_input comparison
        input = gets.strip.to_i
        if input > comparison
            puts "Invalid selection. Please input a valid number."
            get_user_input
        end
        input
    end

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
        puts "(ಸ‿ಸ)"
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