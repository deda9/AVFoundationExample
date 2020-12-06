//
//  AVFoundationExampleApp.swift
//  AVFoundationExample
//
//  Created by Deda on 01.12.20.
//

import SwiftUI
import AVFoundation


@main
struct AVFoundationExampleApp: App {
    
    init() {
        self.setupAVAudioSession()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
    
    private func setupAVAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.ambient)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category.")
        }
    }
}

struct HomeView: View {
    @State private var selectedTab = Tabs.play
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PlayView(viewModel: AudioViewModel())
                .tabItem { Tabs.play.view }
                .tag(Tabs.play)
            
            RecordView(viewModel: RecordAudioViewModel())
                .tabItem { Tabs.record.view }
                .tag(Tabs.record)
        }
    }
}

enum Tabs: Int, CaseIterable {
    case play
    case record
}

extension Tabs {
    var title: String {
        switch self {
        case .play:
            return "play"
        case .record:
            return "record"
        }
    }
}

extension Tabs {
    var icon: String {
        switch self {
        case .play:
            return "film"
        case .record:
            return "viewfinder.circle"
        }
    }
}

extension Tabs {
    var view: some View {
        return tabBarItem(text: title, image: icon)
    }
}

private extension Tabs {
    func tabBarItem(text: String, image: String) -> some View {
        VStack {
            Image(systemName: image)
                .imageScale(.large)
            Text(text)
        }
    }
}
