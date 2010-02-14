# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{icu_ratings}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mark Orr"]
  s.date = %q{2010-02-14}
  s.description = %q{Build an object that represents a chess tournament then get it to calculate ratings of all the players.}
  s.email = %q{mark.j.l.orr@googlemail.com}
  s.extra_rdoc_files = [
    "LICENCE",
     "README.rdoc"
  ]
  s.files = [
    "LICENCE",
     "README.rdoc",
     "VERSION.yml",
     "lib/icu_ratings.rb",
     "lib/icu_ratings/player.rb",
     "lib/icu_ratings/result.rb",
     "lib/icu_ratings/tournament.rb",
     "lib/icu_ratings/util.rb",
     "spec/player_spec.rb",
     "spec/result_spec.rb",
     "spec/spec_helper.rb",
     "spec/tournament_spec.rb",
     "spec/util_spec.rb"
  ]
  s.homepage = %q{http://github.com/sanichi/icu_ratings}
  s.rdoc_options = ["--charset=utf-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{For rating chess tournaments.}
  s.test_files = [
    "spec/player_spec.rb",
     "spec/result_spec.rb",
     "spec/spec_helper.rb",
     "spec/tournament_spec.rb",
     "spec/util_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

