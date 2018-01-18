# -*- encoding: utf-8 -*-
# stub: descriptive-statistics 2.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "descriptive-statistics"
  s.version = "2.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Julian Tescher"]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDKjCCAhKgAwIBAgIBADANBgkqhkiG9w0BAQUFADA7MQ0wCwYDVQQDDAR5b3Vy\nMRUwEwYKCZImiZPyLGQBGRYFZW1haWwxEzARBgoJkiaJk/IsZAEZFgNjb20wHhcN\nMTMwNjE0MTkxMjQ4WhcNMTQwNjE0MTkxMjQ4WjA7MQ0wCwYDVQQDDAR5b3VyMRUw\nEwYKCZImiZPyLGQBGRYFZW1haWwxEzARBgoJkiaJk/IsZAEZFgNjb20wggEiMA0G\nCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC9WjvJinWV7h9VeLlf4+yHxr1LF/8/\nHHFCKYEs/ZrUJLrpmuUWUrkgpwIbV5FUvqkXoCcCvR2z65lAONZtdvg3ygBBXfl7\nrQaNb/EMMzulmf26ztAtUP0Ipaz0pX/qlzDLkDkhXxUB1rUcxuZ2Rif0HsOtQO5d\nMzQfREsYDtWMileLxcImCxtoE5r+tG2sbJ72gxP0QygAwL+mke//C0wPVCBC9zI2\nfwhZmTD2dmyx0JW8C0YR+38kqtMldCcIQOPRH6ue/JAyfxaosYyNLK5zuUoW1MSR\nl1PMWb3fEDXprbnku496f026FAgDn8TFsWDFw+KhHwTgIYASbgopYqWTAgMBAAGj\nOTA3MAkGA1UdEwQCMAAwHQYDVR0OBBYEFM0KCQLMiOjnsL1TEu5IFFRCar4CMAsG\nA1UdDwQEAwIEsDANBgkqhkiG9w0BAQUFAAOCAQEAscW33q8g0jLkAE8jZnIYjbO3\nhhNpSyXO1JmJEbm5q9v5rDqhj8RTbdd100tFwGc2tIViR9edQ8Z72s9gEAdU6N4P\nHpoYcNOqET8Fqs+o16lbk74on6Gv9S5LZjBQ1UuIqDbENuTzogxY25Yx5dIGHyIo\n7rzorf4e4KCNFw19BG5M3ijlMvciSGxIPbmJoaSa7m62sudGr3CrEpRgMZBvp1Ea\nILaPiI1PhVurfov2y0+YT0rbOrv4cWoBWsZ+aww2iSNC5XFhA/8xsK0BltYRF9nP\nHA41UtDxrJkHL3N1z8gPMXSrFT41FR2wgk8+l14P+7g1UTPid2EIwft2xObFeA==\n-----END CERTIFICATE-----\n"]
  s.date = "2014-03-21"
  s.description = "Descriptive Statistics Calculator"
  s.email = ["virulent@gmail.com"]
  s.homepage = "https://github.com/jtescher/descriptive-statistics"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.8"
  s.summary = "Simply calculate descriptive statistics such as measures of central tendency (e.g. mean,median, mode), dispersion (e.g. range and quartiles), and spread (e.g variance and standard deviation)"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.14"])
      s.add_development_dependency(%q<rake>, ["~> 10.1"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_development_dependency(%q<coveralls>, ["~> 0.6"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.14"])
      s.add_dependency(%q<rake>, ["~> 10.1"])
      s.add_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_dependency(%q<coveralls>, ["~> 0.6"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.14"])
    s.add_dependency(%q<rake>, ["~> 10.1"])
    s.add_dependency(%q<simplecov>, ["~> 0.7"])
    s.add_dependency(%q<coveralls>, ["~> 0.6"])
  end
end
