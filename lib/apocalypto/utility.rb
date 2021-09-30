class ApocalyptoApp::Utility
    def fight_shop_exit
        puts "Enter [fight] to kill zombies or [shop] to peruse the wares."
        escape
        input = gets.strip.downcase
        if input == "fight"
            ApocalyptoApp::Zombie.spawn_zombie
        elsif input == "shop"
            ApocalyptoApp::Supply.access_shop
        else
            ApocalyptoApp::CLI.all[-1].list_countries
        end
    end

    def escape
        puts "Enter any key to choose a new area."
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
        puts "ᵒʰ(⑉☆｡☆⑉)ɴᴏ"
        new_line
    end

    def hit
        puts "(ﾉ>｡☆)ﾉ"
        new_line
    end
end