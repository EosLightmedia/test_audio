class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
    App::Persistence["folder_prefs"]                      ||= '~/Museo Video Player'
    App::Persistence["folder_path"]                       ||= File.expand_path(App::Persistence["folder_prefs"])
    # test_2
    # test_1 # This one actually plays audio in single channels - only one file though
    # sync_test1
    
    caf_test #OMG This one works!!
    # audio_kit
    # ez_audio
    # playfile('test', 10, 2, "dummy")
    # buffer = load_sound
    # mp buffer
    # audio_engine
    # audio_player
  end
  
  def caf_test
    
    # https://forums.developer.apple.com/thread/15416

        # # // ------------------------------------------------------------------
        # # // AVAudioEngine setup
        # # // ------------------------------------------------------------------
        # #
        @engine = AVAudioEngine.alloc.init
        @output = @engine.outputNode
        @mixer = @engine.mainMixerNode
        #
        @player = AVAudioPlayerNode.alloc.init
        @engine.attachNode(@player)
        #
        # # // open the file to play
        path = App::Persistence["folder_path"] + "/" + "MainShow.caf"
        soundFileURL = NSURL.fileURLWithPath(path)
        file = AVAudioFile.alloc.initForReading(soundFileURL, error:nil)
        
        
        # file = self.getFileToPlay:@"lpcm_multichannel" ofType:@"caf"];  #// multichannel audio file
        #
        # # // create output channel map
        outputNumChannels = @output.outputFormatForBus(0).channelCount
        mp outputNumChannels
        # NSAssert(outputNumChannels > 0 && outputNumChannels <= 512, @"Error: invalid number of output channels!"); // reasonable bounds
        #
        # outputChannelMap[outputNumChannels]
 #        memset(outputChannelMap, -1, sizeof(outputChannelMap)); #// unmapped
 
        sourceNumChannels = file.processingFormat.channelCount
        mp sourceNumChannels
        sourceChIndex = 0
        # 16.times do |chIndexVal|
        # #     int chIndexVal = [(NSNumber*)chIndex intValue];
        # #
        #     if (chIndexVal < outputNumChannels && sourceChIndex < sourceNumChannels) {
        #         outputChannelMap[chIndexVal] = sourceChIndex;
        #         sourceChIndex++;
        #     }
        # # }
        #
        
        outputChannelMap = Pointer.new(:uint, 15)
        outputChannelMap[0] = 0
        outputChannelMap[1] = 1
        outputChannelMap[2] = 2
        outputChannelMap[3] = 3
        outputChannelMap[4] = 4
        outputChannelMap[5] = 5
        outputChannelMap[6] = 6
        outputChannelMap[7] = 7
        outputChannelMap[8] = 8
        outputChannelMap[9] = 9
        outputChannelMap[10] = 10
        outputChannelMap[11] = 11
        outputChannelMap[12] = 12
        outputChannelMap[13] = 13
        outputChannelMap[14] = 14
        
        # # // set channel map on outputNode AU
        propSize = 60
        
        err = AudioUnitSetProperty(@output.audioUnit, KAudioOutputUnitProperty_ChannelMap, KAudioUnitScope_Global, 0, outputChannelMap, propSize);
        mp err if err > 0
        # NSAssert(noErr == err, @"Error setting channel map! %d", (int)err);
        #
        # # // make connections
        channelLayout = AVAudioChannelLayout.alloc.initWithLayoutTag(KAudioChannelLayoutTag_DiscreteInOrder | sourceNumChannels)
        audioFormat = AVAudioFormat.alloc.initWithStreamDescription(file.processingFormat.streamDescription, channelLayout:channelLayout)
        #
        @engine.connect(@player, to: @mixer, format: audioFormat)
        @engine.connect(@mixer, to:@output, format:audioFormat)
        #
        # # // schedule the file on player
        @player.scheduleFile(file, atTime:nil, completionHandler:nil)
        #
        # # // start engine and player
        success = @engine.startAndReturnError(nil)
        # NSAssert(success, @"Error starting engine! %@", [error localizedDescription]);
        #
        @player.play

        mp 'here'
    
  end
  
  def sync_test1
    path = NSBundle.mainBundle.pathForResource("test", ofType: "wav")
    audioFileURL = NSURL.fileURLWithPath(path)
    file1 = AVAudioFile.alloc.initForReading(audioFileURL, error: nil)
    
    path = NSBundle.mainBundle.pathForResource("test2", ofType: "wav")
    audioFileURL = NSURL.fileURLWithPath(path)
    file2 = AVAudioFile.alloc.initForReading(audioFileURL, error: nil)
    
    outputFormat = AVAudioFormat.alloc.initWithCommonFormat(AVAudioPCMFormatFloat32, sampleRate:file1.processingFormat.sampleRate, channels:1, interleaved:false)

    wholeBuffer = AVAudioPCMBuffer.alloc.initWithPCMFormat(file1.processingFormat, frameCapacity: file1.length)
    
    buffer1 = AVAudioPCMBuffer.alloc.initWithPCMFormat(outputFormat, frameCapacity: file1.length)
    
    buffer2 = AVAudioPCMBuffer.alloc.initWithPCMFormat(outputFormat, frameCapacity: file2.length)
    
    # memcpy(buffer1.audioBufferList->mBuffers[0].mData, wholeBuffer.audioBufferList->mBuffers[0].mData, wholeBuffer.audioBufferList->mBuffers[0].mDataByteSize);
    #
    # memcpy(buffer1.audioBufferList->mBuffers[1].mData, wholeBuffer.audioBufferList->mBuffers[1].mData, wholeBuffer.audioBufferList->mBuffers[1].mDataByteSize);
#     buffer1.frameLength = wholeBuffer.audioBufferList->mBuffers[0].mDataByteSize/sizeof(UInt32);
#     memcpy(buffer2.audioBufferList->mBuffers[0].mData, wholeBuffer.audioBufferList->mBuffers[2].mData, wholeBuffer.audioBufferList->mBuffers[2].mDataByteSize);
#     memcpy(buffer2.audioBufferList->mBuffers[1].mData, wholeBuffer.audioBufferList->mBuffers[3].mData, wholeBuffer.audioBufferList->mBuffers[3].mDataByteSize);
#     buffer2.frameLength = wholeBuffer.audioBufferList->mBuffers[0].mDataByteSize/sizeof(UInt32);
#     memcpy(buffer3.audioBufferList->mBuffers[0].mData, wholeBuffer.audioBufferList->mBuffers[4].mData, wholeBuffer.audioBufferList->mBuffers[4].mDataByteSize);
#     memcpy(buffer3.audioBufferList->mBuffers[1].mData, wholeBuffer.audioBufferList->mBuffers[5].mData, wholeBuffer.audioBufferList->mBuffers[5].mDataByteSize);
#     buffer3.frameLength = wholeBuffer.audioBufferList->mBuffers[0].mDataByteSize/sizeof(UInt32);
#
#     AVAudioEngine *engine = [[AVAudioEngine alloc] init];
#     AVAudioPlayerNode *player1 = [[AVAudioPlayerNode alloc] init];
#     AVAudioPlayerNode *player2 = [[AVAudioPlayerNode alloc] init];
#     AVAudioPlayerNode *player3 = [[AVAudioPlayerNode alloc] init];
#     AVAudioMixerNode *mixer = [[AVAudioMixerNode alloc] init];
#     [engine attachNode:player1];
#     [engine attachNode:player2];
#     [engine attachNode:player3];
#     [engine attachNode:mixer];
#     [engine connect:player1 to:mixer format:outputFormat];
#     [engine connect:player2 to:mixer format:outputFormat];
#     [engine connect:player3 to:mixer format:outputFormat];
#     [engine connect:mixer to:engine.outputNode format:outputFormat];
#     [engine startAndReturnError:nil];
#
#     [player1 scheduleBuffer:buffer1 completionHandler:nil];
#     [player2 scheduleBuffer:buffer2 completionHandler:nil];
#     [player3 scheduleBuffer:buffer3 completionHandler:nil];
#     [player1 play];
#     [player2 play];
#     [player3 play];
  end
  
  def sync_test
    #https://forums.developer.apple.com/thread/14138
    # https://forums.developer.apple.com/thread/16790
  end
  
  def test_1
    #This one works!
    @engine = AVAudioEngine.alloc.init
    @player = AVAudioPlayerNode.alloc.init
    
    output = @engine.outputNode
    outputHWFormat = output.outputFormatForBus(0)
    
    mixer = @engine.mainMixerNode
    @engine.connect(mixer, to: output, format: outputHWFormat)
    @engine.attachNode(@player)
    
    path = NSBundle.mainBundle.pathForResource("test", ofType: "wav")
    audioFileURL = NSURL.fileURLWithPath(path)
    songFile = AVAudioFile.alloc.initForReading(audioFileURL, error: nil)
    
    @engine.connect(@player, to: mixer, format: songFile.processingFormat)

    channelMap = Pointer.new(:uint, 2)
    channelMap[0] = -1
    channelMap[1] = 0
    

    
    # propSize = channelMap.count * sizeof(sint32)
    # mp sizeof(channelMap)
    # mp channelMap.count
    # mp channelMap.methods
    
    
    AudioUnitSetProperty(@engine.inputNode.audioUnit,
                        KAudioOutputUnitProperty_ChannelMap,
                        KAudioUnitScope_Global,
                        1,
                        channelMap,
                        8 )#this is 8 because each value has 4 bytes
                        
                        
    
    time = AVAudioTime.timeWithSampleTime(1, atRate:30)
    
    error = Pointer.new(:object)
    @engine.startAndReturnError(error)
    p error[0].description
    mp @engine.description
    @player.scheduleFile(songFile, atTime: time, completionHandler: nil)
    
    mp 'here'
    
    outputFormat = @player.outputFormatForBus(0)
    startSampleTime = @player.lastRenderTime.sampleTime
    startTime = AVAudioTime.timeWithSampleTime((startSampleTime + (0.25 * outputFormat.sampleRate)), atRate:outputFormat.sampleRate)
    
    mp @player.description
    @player.playAtTime(startTime)
    mp "@player.isPlaying = #{@player.isPlaying}"
  end
  
  def test_2
    #https://stackoverflow.com/questions/21832733/how-to-use-avaudiosessioncategorymultiroute-on-iphone-device/35009801#35009801
    # // Get channel map indices based on user specified channelNames
    # channelMapIndices = ['left','right']

    # NSAssert(channelMapIndices && channelMapIndices.count > 0, "Error getting indices for user specified channel names!")

    # // AVAudioEngine setup
    @engine = AVAudioEngine.alloc.init
    @output = @engine.outputNode
    @mixer = @engine.mainMixerNode;
    @player = AVAudioPlayerNode.alloc.init
    @engine.attachNode(@player)

       # // open the file to play
    path = NSBundle.mainBundle.pathForResource("test", ofType: "wav")
    songURL1 = NSURL.fileURLWithPath(path)
    @songFile = AVAudioFile.alloc.initForReading(songURL1, error:nil)

       # // create output channel map
    source1NumChannels = @songFile.processingFormat.channelCount

       # // I use constant map
       # // Play audio to output channel3, channel4
    outputChannelMap = [-1, 0, -1, -1]

    # // This will play audio to output channel1, channel2
    # //outputChannelMap[4] = {0, 1, -1, -1};

       # // set channel map on outputNode AU
    propSize = outputChannelMap.length * 4 #This is kind of wierd but seems to work.
    mp propSize
    mp sizeof(outputChannelMap)
    err = AudioUnitSetProperty(@output.audioUnit, 
                              KAudioOutputUnitProperty_ChannelMap,
                              KAudioUnitScope_Global, 
                              1, 
                              outputChannelMap, 
                              propSize)
    # NSAssert(noErr == err, "Error setting channel map! #{err}")

    #    # // make connections
    channel1Layout = AVAudioChannelLayout.alloc.initWithLayoutTag(KAudioChannelLayoutTag_DiscreteInOrder | source1NumChannels)
    
    format1 = AVAudioFormat.alloc.initWithStreamDescription(@songFile.processingFormat.streamDescription, channelLayout:channel1Layout)
    @engine.connect(@player, to:@mixer, format:format1)
    @engine.connect(@mixer, to:@output, format:format1)
    
    #    // schedule the file on player
    @player.scheduleFile(@songFile, atTime:nil, completionHandler:nil)
    
    #    // start engine and player
    unless @engine.isRunning
      @engine.startAndReturnError(nil)
    end
       
    @player.play
  end
  
 
  def audio_kit
    path = NSBundle.mainBundle.pathForResource("test", ofType: "wav")
    soundFileURL = NSURL.fileURLWithPath(path)
    mp soundFileURL
    file = AKAudioFile.alloc.initForReading(soundFileURL, error: nil)
    
    mp AudioKit.outputDevices
    # player = AKNode.initWithAvAudioNode()
    
    
    clar = AKClarinet.alloc.init
    clar.start
    
    # AKAudioPlayer.secondsToAVAudioTimeWithHostTime(Time.now)
    # # @player = AKAudioPlayer.alloc.initWithFile(file, looping: true, error:nil, completionHandler: nil)
    # @player.play
    
    @player = EZAudioPlayer.audioPlayerWithDelegate(self)
    @player.shouldLoop = true
    @player.audioFile = EZAudioFile.audioFileWithURL(soundFileURL)
    mp @player
    # @player.play
    
    output = EZOutput.outputWithDataSource()
  end
  
  def audio_kit_test
    #Works!
    oscillator1 = AKOscillator.alloc.init
    oscillator2 = AKOscillator.alloc.init
    mixer = AKMixer.alloc.init([oscillator1, oscillator2])
    mixer.volume = 0.5
    AudioKit.output = mixer
    AudioKit.start
    oscillator1.frequency = (rand() / 1) * 660.0 + 220.0
    oscillator2.frequency = (rand() / 1) * 660.0 + 220.0
    oscillator1.start
    oscillator2.start
  end
  
  def ez_audio
    
    path = App::Persistence["folder_path"] + "/" + "LoadLoop.caf"
    soundFileURL = NSURL.fileURLWithPath(path)

    mp soundFileURL
    @player = EZAudioPlayer.audioPlayerWithDelegate(self)
    @player.shouldLoop = true
    @player.audioFile = EZAudioFile.audioFileWithURL(soundFileURL)
    mp @player
    
    # @player.openFileWithFilePathURL(NSURL.fileURLWithPath(path))
    # mp array = EZAudioDevice.devices
    mp current = EZAudioDevice.currentOutputDevice
    mp current.outputChannelCount
    mp current.name
    @player.play
  end
  
  def audio_player
    path = NSBundle.mainBundle.pathForResource("test", ofType: "wav")
    soundFileURL = NSURL.fileURLWithPath(path)
    @audioPlayer = AVAudioPlayer.alloc.initWithContentsOfURL(soundFileURL, error: nil)
    mp @audioPlayer.numberOfChannels
    @audioPlayer.prepareToPlay()
    @audioPlayer.play()
    mp 'playing?'
    # mp @audioPlayer.channelAssignments
  end
  
  
  def audio_engine
    path = NSBundle.mainBundle.pathForResource("test", ofType: "wav")
    soundFileURL = NSURL.fileURLWithPath(path)
    
    @audioEngine = AVAudioEngine.alloc.init
    @audioPlayerNode = AVAudioPlayerNode.alloc.init
    @mixer = @audioEngine.mainMixerNode
    @changePitchEffect = AVAudioUnitTimePitch.alloc.init
    @changePitchEffect.pitch = 1000
    
    @audioEngine.attachNode(@changePitchEffect)
    
    @audioEngine.connect(@audioPlayerNode, to: @changePitchEffect, format: nil)
    mp 'here'
    
    @audioEngine.connect(@changePitchEffect, to: @audioEngine.outputNode, format: nil)
    file = AVAudioFile.alloc.initForReading(soundFileURL, commonFormat: AVAudioPCMFormatFloat32, interleaved:false, error:nil)
    mp 'here'
    @audioPlayerNode.scheduleFile(file, atTime: nil, completionHandler: nil)
    @audioEngine.start
    @audioPlayerNode.play

  end
  
  def initAVAudioSession
      error = Pointer.new_with_type('@')
    
      # // Configure the audio session
      sessionInstance = AVAudioSession.sharedInstance

      # // set the session category
      success = sessionInstance.setCategory(AVAudioSessionCategoryPlayback error:error)
      # if !success
      #    NSLog("Error setting AVAudioSession category! #{error[0]}"
      #  end
         #
      # const NSInteger desiredNumChannels = 8; #// for 7.1 rendering
      # const NSInteger maxChannels = sessionInstance.maximumOutputNumberOfChannels;
      # if (maxChannels >= desiredNumChannels) {
      #     success = [sessionInstance setPreferredOutputNumberOfChannels:desiredNumChannels error:&error];
      #     if (!success) NSLog(@"Error setting PreferredOuputNumberOfChannels! %@", [error localizedDescription]);
      # }
      #
      #
      # # // add interruption handler
      # [[NSNotificationCenter defaultCenter] addObserver:self
      #                                          selector:@selector(handleInterruption:)
      #                                              name:AVAudioSessionInterruptionNotification
      #                                            object:sessionInstance];
      #
      # # // we don't do anything special in the route change notification
      # [[NSNotificationCenter defaultCenter] addObserver:self
      #                                          selector:@selector(handleRouteChange:)
      #                                              name:AVAudioSessionRouteChangeNotification
      #                                            object:sessionInstance];
      #
      # [[NSNotificationCenter defaultCenter] addObserver:self
      #                                          selector:@selector(handleMediaServicesReset:)
      #                                              name:AVAudioSessionMediaServicesWereResetNotification
      #                                            object:sessionInstance];
      #
      # # // activate the audio session
      # success = [sessionInstance setActive:YES error:&error];
      # if (!success) NSLog(@"Error setting session active! %@\n", [error localizedDescription]);
  end
    
  def load_sound
    path = NSBundle.mainBundle.pathForResource("test", ofType: "wav")
    soundFileURL = NSURL.fileURLWithPath(path)
    mp soundFileURL
    # NSURL *soundFileURL = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:filename ofType:@"caf"]];
    # NSAssert(soundFileURL, "Error creating URL to sound file")
    
    soundFile = AVAudioFile.alloc.initForReading(soundFileURL, commonFormat:AVAudioPCMFormatFloat32, interleaved:false, error: nil)
    # NSAssert(soundFile != nil, "Error creating soundFile, #{error.localizedDescription}")
    
    outputBuffer = AVAudioPCMBuffer.alloc.initWithPCMFormat(soundFile.processingFormat, frameCapacity:soundFile.length)
    success = soundFile.readIntoBuffer(outputBuffer, error:nil)

    outputBuffer
    
  end
  
  def playfile(name, vol, loops, completion)
    filePath = NSBundle.mainBundle.pathForResource("test", ofType: "wav")
    # url = NSURL.fileURLWithPath(path)
    # mp url
    # NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    # if(!filePath)
    #   return nil;
    #     end
	
    # NSError *error = nil;
  	fileURL = NSURL.fileURLWithPath(filePath, isDirectory:false)
  	player = AVAudioPlayer.alloc.initWithContentsOfURL(fileURL, error: nil)
  	player.volume = vol
  	player.numberOfLoops = loops
    # // Retain and play
  	if player
  		players.addObject(player)
  		player.delegate = self
      player.completionBlock = nil
  		player.play
  		return player
    end
  	return nil
    
  end
  
  def playMusic 
    path = NSBundle.mainBundle.pathForResource("test", ofType: "wav")
    url = NSURL.fileURLWithPath(path)
    mp url
    @audioPlayer = AVAudioPlayer.alloc.initWithContentsOfURL(url, error:nil)
    
    
    @audioDeviceManager = AMCoreAudioManager.sharedManager

    mp @audioDeviceManager
    
    mp "All known devices: #{@audioDeviceManager.allKnownDevices.description})"
    
    AVAudioChannelLayout.initWithLayout()
    # //get the default output device
    # AudioObjectPropertyAddress addr
 #    UInt32 size
 #    addr.mSelector = kAudioHardwarePropertyDefaultOutputDevice
 #    addr.mScope = kAudioObjectPropertyScopeGlobal
 #    addr.mElement = 0
 #    size = sizeof(AudioDeviceID)
 #    err = AudioHardwareServiceGetPropertyData(kAudioObjectSystemObject, &addr, 0, NULL, &size, &deviceID)
 #
 #    # //get its sample rate
 #    addr.mSelector = kAudioDevicePropertyNominalSampleRate
 #    addr.mScope = kAudioObjectPropertyScopeGlobal
 #    addr.mElement = 0
 #    size = sizeof(Float64)
 #    Float64 outSampleRate
 #    err = AudioHardwareServiceGetPropertyData(deviceID, &addr, 0, NULL, &size, &outSampleRate)
 #    # //if there is no error, outSampleRate contains the sample rate
 #      # NSApplication.sharedApplication.beginReceivingRemoteControlEvents
    @audioPlayer.play
  end
  
  def play_2 
    path = NSBundle.mainBundle.pathForResource("test", ofType: "wav")
    url = NSURL.fileURLWithPath(path)
    mp url
    
    audioPlayer = AVAudioPlayer.alloc.initWithContentsOfURL(url, error:nil)
    
    # [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    audioPlayer.play
  end
  
  
  def play
    @audioEngine = AVAudioEngine.alloc.init  
          
    outputNode = @audioEngine.outputNode;  
    outputHWFormat = outputNode.outputFormatForBus(0)
    hwChannelLayout = outputHWFormat.channelLayout
    hwLayout = hwChannelLayout.layout
    hwLayoutTag = hwChannelLayout.layoutTag
    hwStreamDescription = outputHWFormat.streamDescription
    hwChannelCount = hwChannelLayout.channelCount
    
    mp hwChannelCount
          
    @mainMixer = @audioEngine.mainMixerNode
    @mainMixer.outputVolume = 1
    @audioEngine.connect(@mainMixer, to:outputNode, format:outputHWFormat)
    
    path = NSBundle.mainBundle.pathForResource("test", ofType: "caf")
    url = NSURL.fileURLWithPath(path)
    mp url
 #    NSError* error = nil;
    @audioFile = AVAudioFile.alloc.initForReading(url, error:nil)
    fileAudioFormat = @audioFile.processingFormat
    mp @audioFile.url
    mp @audioFile.length
    mp @audioFile.fileFormat
    mp fileAudioFormat.channelCount
    
    fileChannelLayout = fileAudioFormat.channelLayout
    mp fileChannelLayout.channelCount
    # AVAudioEngine.outputNode
    
    audioBuffer = AVAudioPCMBuffer(PCMFormat: audioFile.processingFormat,
                                   frameCapacity: (data.length))
    audioFile.readIntoBuffer( audioBuffer )
    
    ae = AVAudioEngine.alloc.init
    player = AVAudioPlayerNode.alloc.init
    ae.attachNode(player)
    ae.connect(player, to: outputNode, format: nil)
    ae.startAndReturnError(nil)
    
    
    
    
    # THIS BIT WORKS - makes a mixer, constructs outputs...
    # mixer = ae.mainMixerNode
    #
    # sr = mixer.outputFormatForBus(0).sampleRate
    #
    #
    #
    #
    # ae.connect(player, to:mixer, format: player.outputFormatForBus(0))
    #
    # mp ae
    #
    # output_channels = ae.outputNode.outputFormatForBus(0).channelCount;
    # mp output_channels
    # if output_channels > 15
    #   mp "YES! It's finally working!"
    # else
    #   mp 'not enough channels'
    # end
    #
    # constructOutputConnectionFormatForEnvironment(ae)
    
    
    # mp @audioFile.fileChannelCount
    # mp fileChannelLayout.layout
    # fileLayout = fileChannelLayout.layout
    # fileLayoutTag = fileChannelLayout.layoutTag
    
    
 #    AudioStreamBasicDescription* fileStreamDescription = fileAudioFormat.streamDescription;
 #    AVAudioChannelCount fileChannelCount = fileChannelLayout.channelCount;
 #
 #    AVAudioPlayerNode* player = [[AVAudioPlayerNode alloc] init];
 #    player.volume = 1;
 #    player.pan = 0;
 #    [self.audioEngine attachNode:player];
 #
 #    [self.audioEngine connect:player to:mainMixer format:fileAudioFormat];
 #
 #    error = nil;
 #    [self.audioEngine startAndReturnError:&error];
 #    }
  end
  
  def constructOutputConnectionFormatForEnvironment(engine)
      # AVAudioFormat *environmentOutputConnectionFormat = nil;
      numHardwareOutputChannels = engine.outputNode.outputFormatForBus(0).channelCount
      
      hardwareSampleRate = engine.outputNode.outputFormatForBus(0).sampleRate
    
      # // if we're connected to multichannel hardware, create a compatible multichannel format for the environment node
      if (numHardwareOutputChannels > 2 && numHardwareOutputChannels != 3)
        numHardwareOutputChannels = 15 if (numHardwareOutputChannels > 16)
        
        # // find an AudioChannelLayoutTag that the environment node knows how to render to
        # // this is documented in AVAudioEnvironmentNode.h
        # AudioChannelLayoutTag environmentOutputLayoutTag;
        #   case (numHardwareOutputChannels) {
        #       case 4:
        #           environmentOutputLayoutTag = kAudioChannelLayoutTag_AudioUnit_4;
        #           break;
        #
        #       case 5:
        #           environmentOutputLayoutTag = kAudioChannelLayoutTag_AudioUnit_5_0;
        #           break;
        #
        #       case 6:
        #           environmentOutputLayoutTag = kAudioChannelLayoutTag_AudioUnit_6_0;
        #           break;
        #
        #       case 7:
        #           environmentOutputLayoutTag = kAudioChannelLayoutTag_AudioUnit_7_0;
        #           break;
        #
        #       case 8:
        #           environmentOutputLayoutTag = kAudioChannelLayoutTag_AudioUnit_8;
        #           break;
        #
        #       default:
        #           # // based on our logic, we shouldn't hit this case
        #           environmentOutputLayoutTag = kAudioChannelLayoutTag_Stereo;
        #           break;
        #   }
        
        mp KAudioChannelLayoutTag_UseChannelDescriptions
        
        environmentOutputLayoutTag = KAudioChannelLayoutTag_UseChannelDescriptions
          # // using that layout tag, now construct a format
        environmentOutputChannelLayout = AVAudioChannelLayout.alloc.initWithLayoutTag(environmentOutputLayoutTag)
        environmentOutputConnectionFormat = AVAudioFormat.alloc.initStandardFormatWithSampleRate(hardwareSampleRate , channelLayout: environmentOutputChannelLayout)
        _multichannelOutputEnabled = true
      
      end
      # else {
      #     // stereo rendering format, this is the common case
      #     environmentOutputConnectionFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:hardwareSampleRate channels:2];
      #     _multichannelOutputEnabled = false;
      # }
    
      return environmentOutputConnectionFormat;
  
  end
  
  def createPlayer(engine)
      # // create a new player and connect it to the environment node
    newPlayer = AVAudioPlayerNode.alloc.init
    engine.attachNode(newPlayer)
    engine.connect(newPlayer, to:_environment,  format:_collisionSoundBuffer.format)
    # collisionPlayerArray insertObject:newPlayer atIndex:[node.name integerValue]];
    #
    # # // pick a rendering algorithm based on the rendering format
    # AVAudio3DMixingRenderingAlgorithm renderingAlgo = _multichannelOutputEnabled ? AVAudio3DMixingRenderingAlgorithmSoundField : AVAudio3DMixingRenderingAlgorithmEqualPowerPanning;
    # newPlayer.renderingAlgorithm = renderingAlgo;
    #
    # # // turn up the reverb blend for this player
    # newPlayer.reverbBlend = 0.3;
  end
  
  
  

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.orderFrontRegardless
  end
end
