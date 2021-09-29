class ApocalyptoApp::Country
    attr_accessor :name, :infected

    def initialize name:, infected:
        @name = name
        @infected = infected
    end
end