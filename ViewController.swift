import UIKit
import AVFoundation

class ViewController: UIViewController {
    var bgmPlayer: AVAudioPlayer?
    var sePlayer: AVAudioPlayer?

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func playSound(player: AVAudioPlayer) {
        guard player.prepareToPlay() else { return }
        player.volume = 1.0
        player.play()
    }
    
    func audioURL(name: String) -> NSURL {
        let filePath = NSBundle.mainBundle().pathForResource(name, ofType: "mp3")
        return NSURL(fileURLWithPath: filePath!)
    }
    
    func playBGM(name: String) {
        do {
            bgmPlayer = try AVAudioPlayer(contentsOfURL: audioURL(name))
            bgmPlayer?.numberOfLoops = -1
            playSound(bgmPlayer!)
        } catch { print("Error") }
    }

    func playSE(name: String) {
        do {
            sePlayer = try AVAudioPlayer(contentsOfURL: audioURL(name))
            sePlayer?.numberOfLoops = 0
            playSound(sePlayer!)
        } catch { print("Error") }
    }
    
    func volumeDown(player: AVAudioPlayer, _ downVolume: Float, _ downInterval: Double) {
        while player.volume > downVolume {
            player.volume -= downVolume
            NSThread.sleepForTimeInterval(downInterval)
        }
    }

    @IBAction func fadeout(sender: AnyObject) {
        guard let player = bgmPlayer else { return }
        guard player.playing else { return }
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue, {
            self.volumeDown(player, 0.1, 0.3)
            self.volumeDown(player, 0.01, 0.1)
            self.volumeDown(player, 0.001, 0.05)
            player.stop()
        })
    }

    @IBAction func stopSound(sender: AnyObject) {
        if let player = bgmPlayer { player.stop() }
    }

    @IBAction func halfSound(sender: AnyObject) {
        if let player = bgmPlayer { player.volume = 0.5 }
    }

    @IBAction func maxSound(sender: AnyObject) {
        if let player = bgmPlayer { player.volume = 1.0 }
    }

    @IBAction func playOpening(sender: AnyObject) { playBGM("opening") }
    @IBAction func playClosing(sender: AnyObject) { playBGM("closing") }
    @IBAction func playThinking(sender: AnyObject) { playBGM("thinking") }
    @IBAction func playSpecial(sender: AnyObject) { playBGM("special") }
    @IBAction func playQuiz(sender: AnyObject) { playSE("quiz") }
    @IBAction func playCorrect(sender: AnyObject) { playSE("correct") }
    @IBAction func playInCorrect(sender: AnyObject) { playSE("incorrect") }
}
