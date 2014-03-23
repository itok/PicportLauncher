Pod::Spec.new do |s|
  s.name         = "PicportLauncher"
  s.version      = "0.0.1"
  s.summary      = "launch Picport."
  s.homepage     = "https://github.com/itok/PicportLauncher"
  s.license      = 'MIT'
  s.author       = { "itok" => "i@itok.jp" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/itok/PicportLauncher.git", :tag => "v0.0.1" }
  s.source_files  = 'Picport/*.{m,h}'
end