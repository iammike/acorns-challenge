require 'capybara'
require 'capybara/cucumber'
require 'capybara/rspec'
require 'site_prism'
require 'webdrivers'
require 'pry'

raw_chrome_browser_version = `/usr/libexec/PlistBuddy -c "print :CFBundleShortVersionString" "/Applications/Google Chrome.app/Contents/Info.plist"` # Ex: "72.0.3626.96\n"
chrome_version = raw_chrome_browser_version.split('.')[0...-1].join('.') # Ex: "72.0.3626"
chrome_driver_version = `curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE_#{chrome_version}` # Ex: "72.0.3626.69"
Webdrivers::Chromedriver.version = chrome_driver_version

Capybara.default_driver = :selenium
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end