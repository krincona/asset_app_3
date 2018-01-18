# -*- encoding: utf-8 -*-
# stub: responsive_active_admin 0.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "responsive_active_admin"
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Hayden Ball"]
  s.date = "2015-06-05"
  s.description = "Responsive styles for ActiveAdmin"
  s.email = ["hayden@haydenball.me.uk"]
  s.homepage = "http://github.com/ball-hayden/responsive_active_admin"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.8"
  s.summary = "Responsive styles for ActiveAdmin"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activeadmin>, [">= 0"])
    else
      s.add_dependency(%q<activeadmin>, [">= 0"])
    end
  else
    s.add_dependency(%q<activeadmin>, [">= 0"])
  end
end
