import SwiftUI

/**
 * StatisticsHistoryView
 *
 * History tab of the statistics screen showing fuel fill-up records.
 * This view displays a chronological list of all fuel fill-ups with
 * the ability to add new records and delete existing ones.
 *
 * Key Features:
 * - Chronological list of fill-up records
 * - Add new fill-up functionality
 * - Delete fill-ups with swipe gestures
 * - Empty state handling
 * - Detailed fill-up information display
 *
 * Architecture:
 * - Uses MVVM pattern with StatisticsViewModel
 * - Sheet presentation for add fill-up
 * - List with swipe-to-delete functionality
 */
struct StatisticsHistoryView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = StatisticsViewModel()
    @State private var showAddFillUp = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.fillUps.isEmpty {
                    EmptyFillUpsState(
                        onAddFillUp: { showAddFillUp = true }
                    )
                } else {
                    FillUpsListSection(
                        fillUps: viewModel.fillUps,
                        onDelete: viewModel.deleteFillUp
                    )
                }
            }
            .navigationTitle("Fuel History")
            .navigationBarItems(
                trailing: Button("Add") {
                    showAddFillUp = true
                }
            )
            .sheet(isPresented: $showAddFillUp) {
                AddFillUpView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Supporting Views

/**
 * Empty Fill-ups State
 *
 * Displays when no fill-up records exist.
 * Provides guidance and action to add the first record.
 */
private struct EmptyFillUpsState: View {
    let onAddFillUp: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "fuelpump")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Records")
                .font(.title)
                .fontWeight(.semibold)
            
            Text("Add your first fuel record")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Add Record", action: onAddFillUp)
                .buttonStyle(DefaultButtonStyle())
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
        }
        .padding()
    }
}

/**
 * Fill-ups List Section
 *
 * Displays the list of fill-up records with delete functionality.
 */
private struct FillUpsListSection: View {
    let fillUps: [FillUp]
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(fillUps.sorted { $0.date > $1.date }) { fillUp in
                FillUpRowView(fillUp: fillUp)
            }
            .onDelete(perform: onDelete)
        }
    }
}

/**
 * Fill-up Row View
 *
 * Individual fill-up record row displaying key information.
 */
struct FillUpRowView: View {
    let fillUp: FillUp
    
    var body: some View {
        HStack {
            FillUpInfoSection(fillUp: fillUp)
            Spacer()
            FillUpMetricsSection(fillUp: fillUp)
        }
        .padding(.vertical, 4)
    }
}

/**
 * Fill-up Info Section
 *
 * Displays date and odometer information.
 */
private struct FillUpInfoSection: View {
    let fillUp: FillUp
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(fillUp.date, style: .date)
                .font(.headline)
            
            Text(String(format: "%.0f km", fillUp.odometer))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

/**
 * Fill-up Metrics Section
 *
 * Displays volume and cost information.
 */
private struct FillUpMetricsSection: View {
    let fillUp: FillUp
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(String(format: "%.1f L", fillUp.volume))
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text(String(format: "$%.2f", fillUp.totalCost))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    StatisticsHistoryView()
}
