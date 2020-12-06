## Learn how to Play audio by AVAudioPlayer

<img src="https://github.com/deda9/AVFoundationExample/blob/main/playAudio.png" width="300px"/>

```Swift
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

func play() {
    guard !self.player.isPlaying else {
        return
    }
    self.player.play()
    self.tracePlayingTime()
}
```

## Learn how to Play audio by AVAudioPlayer

<img src="https://github.com/deda9/AVFoundationExample/blob/main/recordAudio.png" width="300px"/>

```Swift

lazy var recordURL: URL = {
    var documentsURL: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }()

    let url = documentsURL.appendingPathComponent("newRecord.m4a")
    return url
}()

lazy var recorder: AVAudioRecorder = {
    do  {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        let recorder = try AVAudioRecorder.init(url: recordURL, settings: settings)
        recorder.delegate = self
        return recorder
    } catch {
        fatalError(error.localizedDescription)
    }
}()

func record() {
    self.requestRecordPermission { [weak self] permissionGranted, error in
        guard let self = self else { return }
        guard !self.recorder.isRecording else {
            return
        }
        self.recorder.record()
    }
}
```

- You can read the tutorial on [Medium Tutorial Link]()
