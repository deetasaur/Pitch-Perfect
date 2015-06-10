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
    
    /**
    Decreases the speed of the audio playback
    
    :param: sender     The button click
    */
    @IBAction func slowPlayButton(sender: UIButton) {
        stopAudio(sender)
        playAudioWithRate(0.5)
        audioButton.play()
    }
    
    /**
    Increases the speed of the audio playback
    
    :param: sender     The button click
    */
    @IBAction func fastPlayButton(sender: UIButton) {
        stopAudio(sender)
        playAudioWithRate(1.5)
        audioButton.play()
    }
    
    /**
    Increases the pitch of the audio playback
    
    :param: sender     The button click
    */
    @IBAction func chipmunkPlayButton(sender: UIButton) {
        stopAudio(sender)
        playAudioWithPitch(1000)
    }
    
    /**
    Decreases the pitch of the audio playback
    
    :param: sender     The button click
    */
    @IBAction func vaderPlayButton(sender: UIButton) {
        stopAudio(sender)
        playAudioWithPitch(-1000)
    }
    
    /**
    Adds reverberation to the audio playback
    
    :param: sender     The button click
    */
    @IBAction func reverbPlayButton(sender: UIButton) {
        stopAudio(sender)
        playAudioWithReverb(100)
    }
    
    /**
    Adds echo to the audio playback
    
    :param: sender     The button click
    */
    @IBAction func playAudioWithEcho() {
        audioButton.currentTime = 0
        audioButton.play()
        
        // Sets and plays a copy of the audio with a delay
        let delay:NSTimeInterval = 0.02
        var delayTime:NSTimeInterval = audioButtonForEcho.deviceCurrentTime + delay
        
        audioButtonForEcho.currentTime = 0
        audioButtonForEcho.volume = 0.8
        audioButtonForEcho.playAtTime(delayTime)
    }
    
    /**
    Stops all audio
    
    :param: sender     The button click
    */
    @IBAction func stopAudio(sender: UIButton) {
        audioButton.stop()
        audioButtonForEcho.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    /**
    Sets the rate of the audio based on param
    
    :param: rate     The rate with which to play the audio
    */
    func playAudioWithRate(rate: Float) {
        audioButton.currentTime = 0.0
        audioButton.rate = rate
    }
    
    /**
    Sets the pitch of the audio based on param and plays the audio
    
    :param: pitch     The pitch with which to play the audio
    */
    func playAudioWithPitch(pitch: Float) {
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //Sets the pitch of the audio
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        //Connects the pitch to the node and the node to the output
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        //Connects the node to the audio file
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    /**
    Sets the reverb of the audio based on param and plays the audio
    
    :param: reverb     The reverb with which to play the audio
    */
    func playAudioWithReverb(reverb: Float) {
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //Sets the reverb of the audio
        var audioReverb = AVAudioUnitReverb()
        audioReverb.wetDryMix = reverb
        audioEngine.attachNode(audioReverb)
        
        //Connects the reverb to the node and the node to the output
        audioEngine.connect(audioPlayerNode, to: audioReverb, format: nil)
        audioEngine.connect(audioReverb, to: audioEngine.outputNode, format: nil)
        
        //Connects the node to the audio file
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
}
