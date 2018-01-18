# -*- encoding: utf-8 -*-
# stub: postgres_ext 2.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "postgres_ext"
  s.version = "2.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Dan McClain"]
  s.date = "2015-02-03"
  s.description = "Adds missing native PostgreSQL data types to ActiveRecord and convenient querying extensions for ActiveRecord and Arel"
  s.email = ["git@danmcclain.net"]
  s.homepage = "https://github.com/dockyard/postgres_ext"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.8"
  s.summary = "Extends ActiveRecord to handle native PostgreSQL data types"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 4.0.0"])
      s.add_runtime_dependency(%q<arel>, [">= 4.0.1"])
      s.add_runtime_dependency(%q<pg_array_parser>, ["~> 0.0.9"])
      s.add_development_dependency(%q<rake>, ["~> 10.1.0"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<m>, [">= 0"])
      s.add_development_dependency(%q<bourne>, ["~> 1.3.0"])
      s.add_development_dependency(%q<database_cleaner>, [">= 0"])
      s.add_development_dependency(%q<dotenv>, [">= 0"])
      s.add_development_dependency(%q<pg>, ["~> 0.13"])
    else
      s.add_dependency(%q<activerecord>, [">= 4.0.0"])
      s.add_dependency(%q<arel>, [">= 4.0.1"])
      s.add_dependency(%q<pg_array_parser>, ["~> 0.0.9"])
      s.add_dependency(%q<rake>, ["~> 10.1.0"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<m>, [">= 0"])
      s.add_dependency(%q<bourne>, ["~> 1.3.0"])
      s.add_dependency(%q<database_cleaner>, [">= 0"])
      s.add_dependency(%q<dotenv>, [">= 0"])
      s.add_dependency(%q<pg>, ["~> 0.13"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 4.0.0"])
    s.add_dependency(%q<arel>, [">= 4.0.1"])
    s.add_dependency(%q<pg_array_parser>, ["~> 0.0.9"])
    s.add_dependency(%q<rake>, ["~> 10.1.0"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<m>, [">= 0"])
    s.add_dependency(%q<bourne>, ["~> 1.3.0"])
    s.add_dependency(%q<database_cleaner>, [">= 0"])
    s.add_dependency(%q<dotenv>, [">= 0"])
    s.add_dependency(%q<pg>, ["~> 0.13"])
  end
end
