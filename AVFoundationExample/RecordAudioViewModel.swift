import AVFoundation

protocol RecordAudioViewModelProtcol {
    var isRecording: Bool { get }
    func play()
    func record()
    func stop()
}

class RecordAudioViewModel: NSObject, RecordAudioViewModelProtcol {
    
    var didFinishRecording: Bool = false
    var isRecording: Bool {
        self.recorder.isRecording
    }
    
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
    
    lazy var player: AVAudioPlayer = {
        do  {
            let player = try AVAudioPlayer(contentsOf: self.recordURL)
            player.prepareToPlay()
            return player
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    
    func play() {
        if didFinishRecording {
            self.player.play()
        }
    }
    
    func record() {
        self.requestRecordPermission { [weak self] permissionGranted, error in
            guard let self = self else { return }
            guard !self.recorder.isRecording else {
                return
            }
            self.recorder.record()
        }
    }
    
    func stop() {
        guard self.recorder.isRecording else {
            return
        }
        self.recorder.stop()
    }
    
    var recordingSession: AVAudioSession = {
        let session = AVAudioSession.sharedInstance()
        return session
    }()
    
    func requestRecordPermission(completion: @escaping (Bool, Error?) -> Void) {
        do {
            try self.recordingSession.setCategory(.playAndRecord, mode: .default)
            try self.recordingSession.setActive(true)
            self.recordingSession.requestRecordPermission() { allowed in
                completion(allowed, nil)
            }
        } catch {
            completion(false, error)
        }
    }
}

extension RecordAudioViewModel: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.didFinishRecording = flag
        //Update the UI when the recoding is finised
    }
}
