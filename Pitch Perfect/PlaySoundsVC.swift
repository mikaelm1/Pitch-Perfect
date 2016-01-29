//
//  PlaySoundsVC.swift
//  Pitch Perfect
//
//  Created by Mikael Mukhsikaroyan on 1/17/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsVC: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.prepareToPlay()
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
    }
    
    func playAudioWithVaribalePitch(pitch: Float) {
        stopAudioPlayer()
        resetAudioEngine()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func stopAudioPlayer() {
        audioPlayer.stop()
    }
    
    func resetAudioEngine() {
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioAtRate(rate: Float) {
        audioPlayer.rate = rate
        audioPlayer.play()
    }


    @IBAction func stopButtonPressed(sender: AnyObject) {
        stopAudioPlayer()
        audioPlayer.currentTime = 0.0
        resetAudioEngine()
    }
    
    @IBAction func fastVersionButtonPressed(sender: AnyObject) {
        resetAudioEngine()
        stopAudioPlayer()
        playAudioAtRate(2.0)
    }


    @IBAction func slowVersionButtonPressed(sender: AnyObject) {
        resetAudioEngine()
        stopAudioPlayer()
        playAudioAtRate(0.7)
    }
    
    @IBAction func playChpmunkSound(sender: AnyObject) {
        playAudioWithVaribalePitch(1000)
    }

    @IBAction func playDarthVader(sender: AnyObject) {
        playAudioWithVaribalePitch(-1000)
    }

}
