class ApocalyptoApp::Supply
    attr_accessor :name, :type, :value, :cost, :desc
    @@all = []

    def initialize name:, type:, value:, cost:, desc:
        @name = name.downcase.titleize
        @type = type
        @value = value.to_i
        @cost = cost.to_i
        @desc = desc
        @@all << self
    end

    def self.all
        @@all.sort_by!(&:type)
    end
end