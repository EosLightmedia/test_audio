# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'test_audio'
  app.frameworks +=['Cocoa', 'AVFoundation', 'CoreMedia', 'AudioToolbox', 'CoreAudio', 'AudioUnit' ]
  app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true }
    
  # app.embedded_frameworks += ['./vendor/AMCoreAudio.framework']
  app.embedded_frameworks += ['./vendor/AudioKit.framework']
  # app.embedded_frameworks += ['./vendor/EZAudioOSX.framework']
  # app.pods do
  #   use_frameworks!
  #   pod 'AudioKit'
  #   # pod 'EZAudio'
  # end
end
