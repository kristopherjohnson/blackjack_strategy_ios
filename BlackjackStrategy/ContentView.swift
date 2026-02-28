import SwiftUI

struct ContentView: View {
    // Lifted up so StatisticsView shares the same instance as PracticeView
    @State private var gameState = GameState()

    var body: some View {
        TabView {
            PracticeView(gameState: gameState)
                .tabItem {
                    Label("Practice", systemImage: "gamecontroller")
                }

            ReferenceView()
                .tabItem {
                    Label("Reference", systemImage: "book")
                }

            StatisticsView(statisticsStore: gameState.statisticsStore)
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar")
                }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
