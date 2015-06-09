//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Aditya Ramayanam on 6/2/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioButton:AVAudioPlayer!
    var audioButtonForEcho:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioButton = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioButton.enableRate = true
        
        audioButtonForEcho = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)

        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func slowPlayButton(sender: UIButton) {
        audioButton.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioButton.currentTime = 0.0
        audioButton.rate = 0.5
        audioButton.play()
    }

    @IBAction func fastPlayButton(sender: UIButton) {
        audioButton.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioButton.currentTime = 0.0
        audioButton.rate = 1.5
        audioButton.play()
    }
    
    @IBAction func chipmunkPlayButton(sender: UIButton) {
        playAudioWithPitch(1000)
    }
    
    @IBAction func vaderPlayButton(sender: AnyObject) {
        playAudioWithPitch(-1000)
    }
    
    @IBAction func reverbPlayButton(sender: UIButton) {
        playAudioWithReverb(100)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioButton.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playAudioWithEcho() {
        audioButton.stop()
        audioButton.currentTime = 0
        audioButton.play()
        
        let delay:NSTimeInterval = 0.02
        var delayTime:NSTimeInterval = audioButtonForEcho.deviceCurrentTime + delay
        
        audioButtonForEcho.stop()
        audioButtonForEcho.currentTime = 0
        audioButtonForEcho.volume = 0.8
        audioButtonForEcho.playAtTime(delayTime)
    }
    
    func playAudioWithPitch(pitch: Float) {
        audioButton.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playAudioWithReverb(reverb: Float) {
        audioButton.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var audioReverb = AVAudioUnitReverb()
        audioReverb.wetDryMix = reverb
        audioEngine.attachNode(audioReverb)
        
        audioEngine.connect(audioPlayerNode, to: audioReverb, format: nil)
        audioEngine.connect(audioReverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
}
