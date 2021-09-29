class ApocalyptoApp::CLI
    include ApocalyptoApp

    def start
        system("clear")
        puts "Welcome to Apocalypto"
        divider
        new_line
        puts "It's the end of days. A plague has taken over the world, turning people into vicious, flesh eating zombies. The world as you know it is over. Your job now? Survive."
        new_line
        puts "Enter your name to begin"
        puts "Input [exit] to escape the apocalypse."

        input = gets.strip.downcase
        if input == "exit"
            exit
        elsif
            user = User.new input
            list_countries
        end
    end

    def list_countries
    end
end