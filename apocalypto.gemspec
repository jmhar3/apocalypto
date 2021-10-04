Gem::Specification.new do |s|
    s.name        = 'Apocalypto'
    s.version     = '0.0.0'
    s.summary     = "A survival game"
    s.description = "Survive the apocalypse with supplies from the shop while taking down zombies. Gear up to work your way to more difficult areas."
    s.authors     = ["Jessica Hackerman"]
    s.email       = 'jmhar@protonmail.com'
    s.files       = [
        "lib/CLI/cli.rb",
        "lib/CLI/fight.rb",
        "lib/CLI/shop.rb",
        "lib/supply.rb",
        "lib/scraper.rb",
        "lib/utility.rb",
        "lib/player.rb",
        "lib/zombie.rb",
        "lib/country.rb"
    ]
    s.homepage    =
        'https://rubygems.org/gems/apocalypto'
    s.license       = 'MIT'
  end