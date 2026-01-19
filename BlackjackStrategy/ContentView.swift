import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PracticeView()
                .tabItem {
                    Label("Practice", systemImage: "gamecontroller")
                }

            ReferenceView()
                .tabItem {
                    Label("Reference", systemImage: "book")
                }
        }
    }
}

#Preview {
    ContentView()
}
