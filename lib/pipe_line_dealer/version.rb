module PipeLineDealer
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 0
    BETA  = nil
  end

  VERSION = [Version::MAJOR, Version::MINOR, Version::PATCH, Version::BETA].reject(&:nil?).collect(&:to_s).join(".")
end
