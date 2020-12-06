import AVFoundation

protocol AudioViewModelProtcol {
    func play()
    func pause()
    func changeRate(to rate: Double)
    func setVolume(to volume: Double)
    
    var isPlaying: Bool { get }
}

class AudioViewModel: NSObject, AudioViewModelProtcol {
 
    lazy var songURL: URL = {
        let url = Bundle.main.url(forResource: "om", withExtension: "m4a")
        return url!
    }()
    
    lazy var player: AVAudioPlayer = {
        do  {
            let player = try AVAudioPlayer(contentsOf: self.songURL)
            player.delegate = self
            player.numberOfLoops = .max
            player.prepareToPlay()
            return player
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    
    var isPlaying: Bool  {
        self.player.isPlaying
    }
        
    var timer: Timer!
    
    func play() {
        guard !self.player.isPlaying else {
            return
        }
        self.player.play()
        self.tracePlayingTime()
    }
    
    func pause() {
        self.player.pause()
        self.timer.invalidate()
    }
    
    func changeRate(to rate: Double) {
        do {
            self.player = try AVAudioPlayer(contentsOf: self.songURL)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        self.player.enableRate = true
        self.player.rate = Float(rate)
        self.player.play()
    }
    
    func setVolume(to volume: Double) {
        self.player.setVolume(Float(volume), fadeDuration: 0.1)
    }
    
    func tracePlayingTime() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            print("currentTime", self.player.currentTime)
        }
        self.timer.fire()
    }
    
    deinit {
        self.timer.invalidate()
    }
}

extension AudioViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audioPlayer Did FinishPlaying")
    }
    
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        print("audioPlayer Begin Interruption")
    }
    
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        print("audioPlayer End Interruption")
    }
}
