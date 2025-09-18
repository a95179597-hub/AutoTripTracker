import SwiftUI

/**
 * MainTabView
 *
 * Root view of the application that provides tab-based navigation.
 * This view serves as the main container for all primary app screens
 * and follows the standard iOS tab bar pattern.
 *
 * Architecture:
 * - Uses TabView for navigation between main screens
 * - Each tab represents a major app feature
 * - Follows iOS Human Interface Guidelines for tab bar design
 */
struct MainTabView: View {
    
    // MARK: - Body
    
    var body: some View {
        TabView {
            CalculatorView()
                .tabItem {
                    Image(systemName: "steeringwheel.arrow.trianglehead.counterclockwise.and.clockwise")
                    Text("Calculator")
                }
            
            GarageView()
                .tabItem {
                    Image(systemName: "car")
                    Text("Garage")
                }
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                }
        }
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
}
