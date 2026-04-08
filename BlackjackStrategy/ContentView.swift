import SwiftUI

/// Root view containing the three-tab interface: Practice, Reference, and Statistics.
struct ContentView: View {
    /// Shared game state owned here so Practice and Statistics tabs share one instance.
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
