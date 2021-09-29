class ApocalyptoApp::Country
    attr_accessor :name, :infected
    @@all = []

    def initialize name:, infected:
        @name = name
        @infected = infected
        if name != nil && infected!= nil
            @@all << self
        end
    end

    def self.all
        @@all
    end
end