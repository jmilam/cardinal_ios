# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'motion-layout'
require 'bubble-wrap'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Cardinal'
  app.device_family = [:ipad]
  app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true }
  app.identifier = 'smartlock.enduraproducts.com'
  app.codesign_certificate = 'iPhone Distribution: Endura Products, Inc'
  app.interface_orientations = [:landscape_left, :landscape_right]
  app.provisioning_profile = '~/Library/MobileDevice/Provisioning Profiles/42955cf1-ffd9-4308-88bd-adf0680a992f.mobileprovision'
  app.entitlements['get-task-allow'] = false
  #app.deployment_target = '9.3'
  app.deployment_target = '10.0'
  app.version = '1.0.4'
  app.archs["iphoneSimulator"] = ["i386"]
  app.archs["iPhoneOS"] = ["armv7"]
  app.icons = ["cardinal.jpg"]
end


IB::RakeTask.new do |project|
end