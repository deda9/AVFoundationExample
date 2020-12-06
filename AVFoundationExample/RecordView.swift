import SwiftUI

struct RecordView<ViewModel: RecordAudioViewModelProtcol> : View{

    var viewModel: ViewModel
    @State var isRecording = false

    var body: some View {
        
        VStack {
            Text("Is Recording: " + "\(self.isRecording)")
            Button("Record") {
                self.viewModel.record()
                self.isRecording = self.viewModel.isRecording
            }.padding()
            
            Button("Stop Recording") {
                self.viewModel.stop()
                self.isRecording = self.viewModel.isRecording
            }
            
            Button("Play") {
                self.viewModel.play()
                self.isRecording = self.viewModel.isRecording
            }
        }
    }
}
