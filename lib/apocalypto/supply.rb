class ApocalyptoApp::Supply
    attr_accessor :name, :type, :value

    @@all = []

    def initialize name:, type:, value:
        @name = name
        @type = type
        @value = value
        @@all << self
    end

    def self.all
        @@all
    end

    def self.access_shop
        system("clear")
        puts "Stock up on supplies:"
        new_line
        divider
        all.each.with_index(1) do |supply, i|
            puts "#{i}. #{supply.name} +#{supply.value} #{supply.type} - $#{supply.value}"
        end
        prompt_area_selection
    end

    def self.prompt_area_selection
        divider
        new_line
        puts "Please enter a number to purchase an item."
        escape

        input = get_user_input
        input == 0 ? exit : ApocalyptoApp.Player.all[-1].purchase_item item
    end

    def self.get_user_input
        input = gets.strip.to_i
        if input > all.size
            puts "Invalid selection: No country exists."
            puts "Please input a valid number."
            return get_user_input
        end
        input
    end
end