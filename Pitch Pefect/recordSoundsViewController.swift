//
//  recordSoundsViewController.h
//  Pitch Pefect
//
//  Created by John Ceniza on 6/10/15.
//  Copyright (c) 2015 AppDeco. All rights reserved.
//

import UIKit
import AVFoundation

class recordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio! //JC Notes: weird, no need to import? That's pretty cool - I think this is a Swift thing

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordLabel.hidden = true;
    }
    
    override func viewWillAppear(animated: Bool) {
        //JC: great place for showing and hiding parts of screen
        stopButton.hidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        //TODO: record the user's voice
        recordLabel.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        
        //Inside func recordAudio(sender: UIButton)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        /*
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        */
        
        let recordingName = "my_audio.wav"

        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //JC Notes: Don't forget to check if recording is successful
        if (flag) {
        recordedAudio = RecordedAudio()
        recordedAudio.filePathURL = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio) //JC Notes: this method is inherited from UIViewController
        } else {
            println("not working")
            recordButton.enabled = true;
            audioRecorder.stop()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) { //JC Notes: this method inherited from UIViewController
        if (segue.identifier == "stopRecording") {
            
            //JC notes: get destinationViewController right before transitioning so we can pass a variable or call a function for setup
            let playSoundsVC:playSoundViewController = segue.destinationViewController as! playSoundViewController
            
            //JC: grab "recordedAudio" we sent up to (self.performSegueWith...) and set it to data then pass data to playSoundVC as receivedAudio variable
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data;
        }
    }
    
    @IBAction func stopRecord(sender: UIButton) {
        recordLabel.hidden = true;
        recordButton.enabled = true;
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil);
    }
}

