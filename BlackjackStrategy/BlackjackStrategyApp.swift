import SwiftUI

@main
struct BlackjackStrategyApp: App {
    init() {
        // Set launch screen background color
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.backgroundColor = UIColor(Color("LaunchBackground"))
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
