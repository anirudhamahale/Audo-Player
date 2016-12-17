//
//  ViewController.swift
//  AudioPlayer
//
//  Created by LA Argon on 12/16/16.
//  Copyright © 2016 com.letsappit. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {

    var player = AVAudioPlayer()
    var songName = "Closer"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        volume.value = 0.05
        configurePlayer()
    }
    
    func configurePlayer() {
        guard let filePath = NSBundle.mainBundle().pathForResource(songName, ofType: "mp3") else {
            return
        }
        
        do {
            try player = AVAudioPlayer(contentsOfURL: NSURL(string: filePath)!)
            player.prepareToPlay()
            player.delegate = self
            player.volume = volume.value
            configureTimingSlider()
            
            // configure session to play in background mode.
            let playerSession = AVAudioSession.sharedInstance()
            
            do {
                try playerSession.setCategory(AVAudioSessionCategoryPlayback)
            } catch {
                print("error")
            }
            
        } catch {
            print("error")
        }
    }
    
    @IBOutlet weak var pause: UIButton!
    @IBAction func pause(sender: AnyObject) {
        if checkIfSongExists() {
            if player.playing {
                player.pause()
                UIView.animateWithDuration(0.3, delay: 0.0, options: [UIViewAnimationOptions.CurveEaseIn], animations: {
                    self.pause.setTitle("Play", forState: .Normal)
                    }, completion: nil)
            } else {
                player.play()
                UIView.animateWithDuration(0.3, delay: 0.0, options: [UIViewAnimationOptions.CurveEaseIn], animations: {
                    self.pause.setTitle("Pause", forState: .Normal)
                    }, completion: nil)
            }
        } else {
            let mediaPicker = MPMediaPickerController(mediaTypes: .Music)
            mediaPicker.delegate = self
            presentViewController(mediaPicker, animated: true, completion: nil)
            
//            let alert = UIAlertController(title: "Song not found", message: "Couldn't find song with name \(songName)", preferredStyle: .Alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var reset: UIButton!
    @IBAction func reset(sender: AnyObject) {
        if checkIfSongExists() {
            player.currentTime = 0
            player.play()
            UIView.animateWithDuration(0.3, delay: 0.0, options: [UIViewAnimationOptions.CurveEaseIn], animations: {
                self.pause.setTitle("Pause", forState: .Normal)
                }, completion: nil)
            UIView.animateWithDuration(0.3, delay: 0.0, options: [UIViewAnimationOptions.CurveEaseIn], animations: {
                self.timingSlider.value = Float(self.player.currentTime)
                }, completion: nil)
            
        } else {
            let mediaPicker = MPMediaPickerController(mediaTypes: .Music)
            mediaPicker.delegate = self
            presentViewController(mediaPicker, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var volume: UISlider!
    @IBAction func volume(sender: AnyObject) {
        if checkIfSongExists() {
            player.volume = volume.value
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var timingSlider: UISlider!
    @IBAction func timingSlider(sender: AnyObject) {
        if checkIfSongExists() {
            player.currentTime = NSTimeInterval(timingSlider.value)
        }
    }
    
    func configureTimingSlider() {
        timingSlider.maximumValue = Float(player.duration)
        timingSlider.value = 0.0
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.updateSliderTime), userInfo: nil, repeats: true)
    }
    
    func updateSliderTime() {
        timingSlider.value = Float(player.currentTime)
    }
    
    func checkIfSongExists() -> Bool {
        guard let _ = NSBundle.mainBundle().pathForResource(songName, ofType: "mp3") else {
            return false
        }
        return true
    }
    
    func playSong(filePath: String) {
        do {
            try player = AVAudioPlayer(contentsOfURL: NSURL(string: filePath)!)
            player.prepareToPlay()
            player.delegate = self
            player.volume = volume.value
            configureTimingSlider()
            
            // configure session to play in background mode.
            let playerSession = AVAudioSession.sharedInstance()
            
            do {
                try playerSession.setCategory(AVAudioSessionCategoryPlayback)
            } catch {
                print("error")
            }
            
        } catch {
            print("error")
        }
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            pause.setTitle("Play", forState: .Normal)
        }
    }
}

extension ViewController: MPMediaPickerControllerDelegate {
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        for item in mediaItemCollection.items {
            print(item.albumTitle)
            guard let url: NSURL = item.valueForProperty(MPMediaItemPropertyAssetURL) as? NSURL else {
                return
            }
            
            do {
                try player = AVAudioPlayer(contentsOfURL: url)
                player.prepareToPlay()
                player.delegate = self
                player.volume = volume.value
                configureTimingSlider()
                
                // configure session to play in background mode.
                let playerSession = AVAudioSession.sharedInstance()
                
                do {
                    try playerSession.setCategory(AVAudioSessionCategoryPlayback)
                } catch {
                    print("error")
                }
                
            } catch {
                print("error")
            }
        }
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}








