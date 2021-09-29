class ApocalyptoApp::Supply
    attr_accessor :name, :type, :value

    def initialize name:, type:, value:
        @name = name
        @type = type
        @value = value
    end

    def self.access_shop
        ApocalyptoApp::Player[-1].player_stats
    end
end