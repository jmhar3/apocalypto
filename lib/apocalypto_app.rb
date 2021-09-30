module ApocalyptoApp
    def fight_shop_exit
        escape
        input = gets.strip.downcase
        if input == "fight"
            ApocalyptoApp::Zombie.spawn_zombie
        elsif input == "shop"
            ApocalyptoApp::Supply.access_shop
        else
            exit
        end
    end

    def escape
        puts "Enter any key to escape the apocalypse."
    end
    
    def new_line
        puts ""
    end

    def divider
        puts "═════════ ∘◦ ❈ ◦∘ ═════════"
    end

    def zombie
        puts "‿︵‿︵(ಥ﹏ಥ)‿︵‿︵"
    end

    def hit_zombie
        puts "‿︵‿︵(ಥ﹏☆)‿︵‿︵"
    end

    def dead_zombie
        puts "‿︵‿︵(☆﹏☆)‿︵‿︵"
    end

    def oh_no
        puts "ᵒʰ(⑉・̆⌓・̆⑉)ɴᴏ"
    end

    def dazed
        puts "ᵒʰ(⑉☆｡☆⑉)ɴᴏ"
    end

    def hit
        puts "(ﾉ>｡☆)ﾉ"
    end
end

require_relative '../config/environment.rb'
require 'pry'
require 'nokogiri'
require 'open-uri'

require_relative '../lib/apocalypto/cli.rb'
require_relative '../lib/apocalypto/country.rb'
require_relative '../lib/apocalypto/player.rb'
require_relative '../lib/apocalypto/zombie.rb'
require_relative '../lib/apocalypto/scraper.rb'
require_relative '../lib/apocalypto/supply.rb'
require_relative '../lib/apocalypto_app.rb'