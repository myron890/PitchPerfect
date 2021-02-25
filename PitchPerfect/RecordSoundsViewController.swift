//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Myron Govender on 2021/01/30.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    func buttonInitialization(isRecording: Bool) {
        recordButton.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
        if isRecording {
            recordingLabel.text = "Recording in progress"
        } else {
            recordingLabel.text = "Tap to Record"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecordingButton.isEnabled = false
    }
    
    //MARK: - recordAudio Function
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        
        buttonInitialization(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //MARK: - stopRecording Function
    
    @IBAction func stopRecording(_ sender: Any) {
        
        buttonInitialization(isRecording: false)

        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: - Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    // MARK: - prepareForSegue Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Thank you for your suggestion regarding storing the identifier in a string. I would like to keep the code this way for now (if possible) as I do find the code more readable.
        
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

