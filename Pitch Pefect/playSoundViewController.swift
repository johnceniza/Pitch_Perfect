//
//  playSoundViewController.swift
//  Pitch Pefect
//
//  Created by John Ceniza on 6/11/15.
//  Copyright (c) 2015 AppDeco. All rights reserved.
//

import UIKit
import AVFoundation

class playSoundViewController: UIViewController {

    //JC Notes: declare audioPlayer as a GLOBAL variable to be used on all functions
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine! //JC: delcare global variable AVAudioEngine type
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //JC Notes: get file path and convert string to NSURL (b/c avaudioPlayer wants NSURL)
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
//            var filePathURL = NSURL.fileURLWithPath(filePath)
//            
//
//            
//        } else {
//            println("the filePath is empty")
//        }
        
        //JC Notes: initalize audio player here before using in IBAction below

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine() //JC: initalize avaudioengine global var
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSoundSlow(sender: UIButton) {
        //JC Notes: good practice to stop audio player before playing it again. Change rate to slow playback. Play loaded file (based on NSURL above in viewDidLoad)
        //current time resets time back to zero otherwise it just keeps playing from where it left off
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        //JC Notes: good practice to stop audio player before playing it again. Change rate to slow playback. Play loaded file (based on NSURL above in viewDidLoad)
        audioPlayer.stop()
        audioPlayer.rate = 2.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000) //JC: change pitch to 1000 using audio engine node AVAudioUnitTimePitch
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000) //JC: call function playAudioWithVariablePitch and set pitch to -1000
    }

    func playAudioWithVariablePitch(pitch: Float) {
        //JC: stop all sounds playing and reset audio engine
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        //JC: create variable AVAudioPlayerNode which we can load sounds and add effects to. Then we attach this to the audio engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //JC: create variable AVAudioPlayerNode which we can load sounds and add effects to. Then we change the pitch and attach this to the audio engine
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        //JC: connect player node to pitch effect and pitch effect to output (sort of like a daisy chain of effects)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    @IBAction func stopAllSounds(sender: UIButton) {
        audioPlayer.stop()
    }
}
