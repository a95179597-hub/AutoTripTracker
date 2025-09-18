import SwiftUI

/**
 * StatisticsView
 *
 * Main statistics screen with tabbed interface for history and charts.
 * This view provides access to fuel consumption history and statistical
 * analysis through a segmented control interface.
 *
 * Key Features:
 * - Tabbed interface (History/Charts)
 * - Fuel consumption history management
 * - Statistical charts and analysis
 * - Data visualization
 *
 * Architecture:
 * - Uses MVVM pattern with StatisticsViewModel
 * - Segmented control for tab switching
 * - Conditional view rendering based on selection
 */
struct StatisticsView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = StatisticsViewModel()
    @State private var selectedTab = 0
    @State private var viewID = UUID()
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack {
                TabPickerSection(selectedTab: $selectedTab)
                
                TabContentSection(
                    selectedTab: selectedTab,
                    viewModel: viewModel
                )
                .id(viewID)
            }
            .navigationTitle("Statistics")
        }
        .onAppear {
            viewID = UUID()
        }
    }
}

// MARK: - Supporting Views

/**
 * Tab Picker Section
 *
 * Segmented control for switching between history and charts tabs.
 */
private struct TabPickerSection: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        Picker("Tab", selection: $selectedTab) {
            Text("History").tag(0)
            Text("Charts").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}

/**
 * Tab Content Section
 *
 * Conditional content rendering based on selected tab.
 */
private struct TabContentSection: View {
    let selectedTab: Int
    let viewModel: StatisticsViewModel
    
    var body: some View {
        if selectedTab == 0 {
            StatisticsHistoryView()
        } else {
            StatisticsChartsView()
        }
    }
}

// MARK: - Preview

#Preview {
    StatisticsView()
}
