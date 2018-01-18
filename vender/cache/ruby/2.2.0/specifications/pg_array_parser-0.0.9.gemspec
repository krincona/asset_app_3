# -*- encoding: utf-8 -*-
# stub: pg_array_parser 0.0.9 ruby lib
# stub: ext/pg_array_parser/extconf.rb

Gem::Specification.new do |s|
  s.name = "pg_array_parser"
  s.version = "0.0.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Dan McClain"]
  s.date = "2013-08-02"
  s.description = "Simple library to parse PostgreSQL arrays into a array of strings"
  s.email = ["git@danmcclain.net"]
  s.extensions = ["ext/pg_array_parser/extconf.rb"]
  s.files = ["ext/pg_array_parser/extconf.rb"]
  s.homepage = "https://github.com/dockyard/pg_array_parser"
  s.rubygems_version = "2.4.8"
  s.summary = "Converts PostgreSQL array strings into arrays of strings"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.11.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.9.2.2"])
      s.add_development_dependency(%q<rake-compiler>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.11.0"])
      s.add_dependency(%q<rake>, ["~> 0.9.2.2"])
      s.add_dependency(%q<rake-compiler>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.11.0"])
    s.add_dependency(%q<rake>, ["~> 0.9.2.2"])
    s.add_dependency(%q<rake-compiler>, [">= 0"])
  end
end
