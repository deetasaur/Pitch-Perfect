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
        resumeRecordingButton.hidden = true
        stopRecordingButton.hidden   = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
    Records audio from microphone and saves the file in the Documents folder.
    
    :param: sender     The button click
    */
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
    
    /**
    Pauses the recording and changes the label to show that recording has been paused
    
    :param: sender     The button click
    */
    @IBAction func pauseRecording(sender: UIButton) {
        recordingButton.hidden       = true
        recordingLabel.text          = "Paused"
        recordingLabel.textColor     = UIColor(red: 0.0, green: 0.004, blue: 0.502, alpha: 1.0)
        pauseRecordingButton.hidden  = true
        resumeRecordingButton.hidden = false
        
        audioRecorder.pause()
    }
    
    /**
    Resumes recording from where it previously left off and changes the label to show that recording has resumed
    
    :param: sender     The button click
    */
    @IBAction func resumeRecording(sender: UIButton) {
        recordingButton.hidden       = false
        recordingLabel.text          = "Recording..."
        recordingLabel.textColor     = UIColor(red: 0.502, green: 0.004, blue: 0.0, alpha: 1.0)
        pauseRecordingButton.hidden  = false
        resumeRecordingButton.hidden = true
        
        audioRecorder.record()
    }
    
    /**
    Stops the recording
    
    :param: sender     The button click
    */
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
    
    /**
    As soon as the recording is finished, calls the function to transition screen
    
    :param: recorder     The recorder that recorded the audio
    :param: flag         Flag to indicate whether the recording was successful
    */
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    /**
    Transitions app to the next view
    
    :param: segue          The view to transition to
    :param: sender         the recorded audio
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
}

