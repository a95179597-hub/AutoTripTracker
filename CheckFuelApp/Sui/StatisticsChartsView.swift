import SwiftUI

/**
 * StatisticsChartsView
 *
 * Charts tab of the statistics screen showing data visualization.
 * This view displays various charts and statistics including consumption
 * history, monthly costs, and price trends.
 *
 * Key Features:
 * - Overview cards with key metrics
 * - Real consumption history chart
 * - Monthly costs chart
 * - Fuel price history chart
 * - Empty state handling for charts
 *
 * Architecture:
 * - Uses MVVM pattern with StatisticsViewModel
 * - LazyVGrid for overview cards
 * - Custom chart components for data visualization
 */
struct StatisticsChartsView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = StatisticsViewModel()
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                OverviewCardsSection(viewModel: viewModel)
                
                RealConsumptionChartSection(viewModel: viewModel)
                
                MonthlyCostsChartSection(viewModel: viewModel)
                
                PriceHistoryChartSection(viewModel: viewModel)
                
                Spacer(minLength: 50)
            }
        }
    }
}

// MARK: - Supporting Views

/**
 * Overview Cards Section
 *
 * Displays key metrics in a grid layout.
 */
private struct OverviewCardsSection: View {
    let viewModel: StatisticsViewModel
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCardView(
                title: "Total Distance",
                value: String(format: "%.0f km", viewModel.totalDistance),
                icon: "road.lanes"
            )
            
            StatCardView(
                title: "Total Fuel",
                value: String(format: "%.1f L", viewModel.totalFuel),
                icon: "fuelpump"
            )
            
            StatCardView(
                title: "Total Cost",
                value: String(format: "$%.2f", viewModel.totalCost),
                icon: "dollarsign.circle"
            )
            
            StatCardView(
                title: "Avg Consumption",
                value: String(format: "%.1f L/100km", viewModel.averageConsumption),
                icon: "speedometer"
            )
        }
        .padding(.horizontal)
    }
}

/**
 * Real Consumption Chart Section
 *
 * Displays the real consumption history chart.
 */
private struct RealConsumptionChartSection: View {
    let viewModel: StatisticsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Real Average Consumption")
                .font(.headline)
                .padding(.horizontal)
            
            if viewModel.realConsumptionHistory.isEmpty {
                EmptyChartState(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "No data for chart",
                    subtitle: "Add fuel records to build the chart"
                )
            } else {
                RealConsumptionChart(data: viewModel.realConsumptionHistory)
                    .frame(height: 200)
                    .padding(.horizontal)
            }
        }
    }
}

/**
 * Monthly Costs Chart Section
 *
 * Displays the monthly costs chart.
 */
private struct MonthlyCostsChartSection: View {
    let viewModel: StatisticsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Monthly Costs")
                .font(.headline)
                .padding(.horizontal)
            
            if viewModel.monthlyCosts.isEmpty {
                EmptyChartState(
                    icon: "chart.bar",
                    title: "No data for chart",
                    subtitle: nil
                )
            } else {
                MonthlyCostsChart(data: viewModel.monthlyCosts)
                    .frame(height: 200)
                    .padding(.horizontal)
            }
        }
    }
}

/**
 * Price History Chart Section
 *
 * Displays the fuel price history chart.
 */
private struct PriceHistoryChartSection: View {
    let viewModel: StatisticsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fuel Price History")
                .font(.headline)
                .padding(.horizontal)
            
            if viewModel.priceHistory.isEmpty {
                EmptyChartState(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "No data for chart",
                    subtitle: nil
                )
            } else {
                PriceHistoryChart(data: viewModel.priceHistory)
                    .frame(height: 200)
                    .padding(.horizontal)
            }
        }
    }
}

/**
 * Empty Chart State
 *
 * Displays when no data is available for a chart.
 */
private struct EmptyChartState: View {
    let icon: String
    let title: String
    let subtitle: String?
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

/**
 * Stat Card View
 *
 * Individual overview card component.
 */
struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

/**
 * Real Consumption Chart
 *
 * Simple bar chart for real consumption data.
 */
struct RealConsumptionChart: View {
    let data: [(Date, Double)]
    
    var body: some View {
        VStack {
            Text("Real Consumption Chart")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    VStack {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 20, height: CGFloat(item.1 * 10))
                        
                        Text(String(format: "%.1f", item.1))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

/**
 * Monthly Costs Chart
 *
 * Simple bar chart for monthly costs data.
 */
struct MonthlyCostsChart: View {
    let data: [(String, Double)]
    
    var body: some View {
        VStack {
            Text("Monthly Costs Chart")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    VStack {
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: 20, height: CGFloat(item.1 / 100))
                        
                        Text(String(format: "%.0f", item.1))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

/**
 * Price History Chart
 *
 * Simple bar chart for price history data.
 */
struct PriceHistoryChart: View {
    let data: [(Date, Double)]
    
    var body: some View {
        VStack {
            Text("Price History Chart")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    VStack {
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: 20, height: CGFloat(item.1 * 5))
                        
                        Text(String(format: "%.1f", item.1))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    StatisticsChartsView()
}
