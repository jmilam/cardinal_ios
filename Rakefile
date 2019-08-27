# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'motion-layout'
require 'motion-cocoapods'
require 'bubble-wrap'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.

  # app.name = 'Cardinal'
  # app.version = '2.0.26'
  # app.provisioning_profile = '~/Library/MobileDevice/Provisioning Profiles/Cardinal2018.mobileprovision'
  # app.identifier = 'com.enduraproducts.cardinal'

  app.name = 'Cardinal Test'
  app.version = '2.0.61'
  app.provisioning_profile = '~/Library/MobileDevice/Provisioning Profiles/CardinalTest2019.mobileprovision'
  app.identifier = 'com.enduraproducts.cardinaltest'

  app.device_family = [:ipad]
  app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true }
  app.codesign_certificate = 'iPhone Distribution: Endura Products, Inc'
  app.interface_orientations = [:landscape_left, :landscape_right]
  app.entitlements['get-task-allow'] = false

  app.archs["iphoneSimulator"] = ["i386"]

  # app.archs["iPhoneOS"] = ["armv7"]
  app.icons = ["cardinal.jpg"]
end


IB::RakeTask.new do |project|
end