//
//  RecordSoundsVC.swift
//  Pitch Perfect
//
//  Created by Mikael Mukhsikaroyan on 1/17/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsVC: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var recordingPaused = false
    var finishedRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        pauseButton.hidden = true
        recordButton.enabled = true
        recordingLabel.text = "Tap To Record"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsVC
            playSoundsVC.receivedAudio = sender as! RecordedAudio 
            
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag && finishedRecording {
            recordedAudio = RecordedAudio(filePath: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else if recordingPaused {
            recordedAudio = RecordedAudio(filePath: recorder.url, title: recorder.url.lastPathComponent!)
        } else {
            showAlert()
            recordButton.enabled = true
            stopButton.hidden = true
        }
        
    }
    
    func showAlert() {
        let controller = UIAlertController()
        controller.title = "Recording was not successful."
        controller.message = "Your audio was not recorded. Please try again."
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        controller.addAction(okAction)
        self.presentViewController(controller, animated: true, completion: nil)
        
    }


    @IBAction func recordButtonPressed(sender: UIButton) {
        recordingLabel.text = "Recording..."
        stopButton.hidden = false
        pauseButton.hidden = false 
        recordButton.enabled = false
        
        // Get the user's directory path
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // Set up audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        
        // Initialize and prepare the recorder
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled  = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func pauseButtonPressed(sender: UIButton) {
        if recordingPaused {
            recordingLabel.text = "Recording..."
            audioRecorder.record()
            recordingPaused = false
            pauseButton.setImage(UIImage(named: "pause"), forState: .Normal)
        } else {
            recordingLabel.text = "Tap to Resume"
            audioRecorder.pause()
            recordingPaused = true
            pauseButton.setImage(UIImage(named: "resume"), forState: .Normal)
        }
    }

    @IBAction func stopButtonPressed(sender: AnyObject) {
        recordingLabel.text = "Tap To Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        finishedRecording = true 
    }
    
}



















