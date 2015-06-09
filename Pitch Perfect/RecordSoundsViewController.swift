//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Aditya Ramayanam on 6/1/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var tapToRecord:           UILabel!
    @IBOutlet weak var recordingLabel:        UILabel!
    @IBOutlet weak var pauseLabel:            UILabel!
    @IBOutlet weak var microphone:            UIButton!
    @IBOutlet weak var recordingButton:       UIButton!
    @IBOutlet weak var pauseRecordingButton:  UIButton!
    @IBOutlet weak var stopRecordingButton:   UIButton!
    @IBOutlet weak var resumeRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        tapToRecord.hidden           = false
        microphone.enabled           = true
        recordingButton.hidden       = true
        recordingLabel.hidden        = true
        pauseRecordingButton.hidden  = true
        pauseLabel.hidden            = true
        resumeRecordingButton.hidden = true
        stopRecordingButton.hidden   = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func recordAudio(sender: UIButton) {
        tapToRecord.hidden          = true
        microphone.enabled          = false
        recordingButton.hidden      = false
        recordingButton.enabled     = false
        recordingLabel.hidden       = false
        pauseRecordingButton.hidden = false
        stopRecordingButton.hidden  = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
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
    
    @IBAction func pauseRecording(sender: UIButton) {
        recordingButton.hidden       = true
        recordingLabel.hidden        = true
        pauseRecordingButton.hidden  = true
        pauseLabel.hidden            = false
        resumeRecordingButton.hidden = false
        
        audioRecorder.pause()
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        recordingButton.hidden       = false
        recordingLabel.hidden        = false
        pauseRecordingButton.hidden  = false
        pauseLabel.hidden            = true
        resumeRecordingButton.hidden = true
        
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        tapToRecord.hidden           = false
        microphone.enabled           = true
        recordingButton.hidden       = true
        recordingLabel.hidden        = true
        pauseRecordingButton.hidden  = true
        resumeRecordingButton.hidden = true
        stopRecordingButton.hidden   = true
        
        audioRecorder.stop()
        
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
}

