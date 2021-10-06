Gem::Specification.new do |s|
    s.name        = 'apocalypto'
    s.version     = '0.0.0'
    s.summary     = "A survival game"
    s.description = "Survive the apocalypse with supplies from the shop while taking down zombies. Gear up to work your way to more difficult areas."
    s.authors     = ["Jessica Hackerman"]
    s.email       = 'jmhar@protonmail.com'
    s.files       = [
        "lib/apocalypto/CLI/cli.rb",
        "lib/apocalypto/CLI/fight.rb",
        "lib/apocalypto/CLI/shop.rb",
        "lib/apocalypto/supply.rb",
        "lib/apocalypto/scraper.rb",
        "lib/apocalypto/utility.rb",
        "lib/apocalypto/player.rb",
        "lib/apocalypto/zombie.rb",
        "lib/apocalypto/country.rb",
        "lib/apocalypto_app.rb",
        "config/environment.rb",
        "bin/apocalypto",
        "README.md",
        "LICENSE"
    ]
    s.homepage    =
        'https://rubygems.org/gems/apocalypto'
    s.license       = 'MIT'
    s.executables << "apocalypto"
    s.add_dependency "open-uri"
    s.add_dependency "nokogiri"
    s.add_dependency "titleize"
  end