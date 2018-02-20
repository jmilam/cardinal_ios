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

  # app.name = 'Cardinal'
  # app.version = '2.0.12'
  # app.provisioning_profile = '~/Library/MobileDevice/Provisioning Profiles/898767a3-0d05-441a-bf9d-4327c9ac44e4.mobileprovision'
  # app.identifier = 'com.enduraproducts.cardinal'

  app.name = 'Cardinal Test'
  app.version = '2.0.11'
  app.provisioning_profile = '~/Library/MobileDevice/Provisioning Profiles/c02807cf-a275-4ada-8751-90107b08ccc1.mobileprovision'
  app.identifier = 'com.enduraproducts.cardinaltest'

  app.device_family = [:ipad]
  app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true }
  app.codesign_certificate = 'iPhone Distribution: Endura Products, Inc'
  app.interface_orientations = [:landscape_left, :landscape_right]
  app.entitlements['get-task-allow'] = false
  app.deployment_target = '11.0'
  app.archs["iphoneSimulator"] = ["i386"]
  # app.archs["iPhoneOS"] = ["armv7"]
  app.icons = ["cardinal.jpg"]

  app.pods do
    pod 'AFNetworking'
  end
end


IB::RakeTask.new do |project|
end