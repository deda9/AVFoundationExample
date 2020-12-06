import SwiftUI

struct PlayView<ViewModel: AudioViewModelProtcol> : View{
    var viewModel: ViewModel
    
    @State var isPlaying = false
    @State private var currentRate: Double = 1
    @State private var currentVolume: Double = 1
    
    var body: some View {
        
        VStack(spacing: 5) {
            Text("Is playing: " + "\(self.isPlaying)").padding()
            
            VStack(spacing: 5) {
                Button("Play") {
                    self.viewModel.play()
                    self.isPlaying = self.viewModel.isPlaying
                }
                
                Button("Pause") {
                    self.viewModel.pause()
                    self.isPlaying = self.viewModel.isPlaying
                }
                
                VStack {
                    HStack {
                        Text("0.5")
                        Slider(value: $currentRate, in: 0.5...5, step: 0.5) { _ in
                            self.viewModel.changeRate(to: self.currentRate)
                            self.isPlaying = self.viewModel.isPlaying
                        }
                        .frame(width: 260)
                        Text("5")
                    }
                    Text("Change Rate " + "\(currentRate)")
                }
                
                VStack {
                    HStack {
                        Text("1")
                        Slider(value: $currentVolume, in: 1...10, step: 1) { _ in
                            self.viewModel.setVolume(to: self.currentVolume)
                        }
                        .frame(width: 260)
                        Text("10")
                    }
                    
                    Text("Set Volume " + "\(self.currentVolume)")
                }
            }
        }
    }
}
