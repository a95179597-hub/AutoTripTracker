import SwiftUI

/**
 * VehicleSelectionView
 *
 * Modal view for selecting a vehicle from the garage.
 * This view provides a list of available vehicles and handles
 * the selection process with proper state management.
 *
 * Key Features:
 * - Displays list of available vehicles
 * - Handles empty state with helpful message
 * - Supports vehicle selection and dismissal
 * - Updates parent view model on selection
 *
 * Architecture:
 * - Uses @ObservedObject for view model binding
 * - Sheet presentation from parent view
 * - Proper state management for selection
 */
struct VehicleSelectionView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: CalculatorViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.vehicles.isEmpty {
                    EmptyVehiclesState()
                } else {
                    VehicleListSection(
                        vehicles: viewModel.vehicles,
                        selectedVehicle: viewModel.selectedVehicle,
                        onVehicleSelected: { vehicle in
                            viewModel.selectVehicle(vehicle)
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
            }
            .navigationTitle("Select Vehicle")
            .navigationBarItems(
                trailing: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .onAppear {
                viewModel.loadVehicles()
            }
        }
    }
}

// MARK: - Supporting Views

/**
 * Empty Vehicles State
 *
 * Displays when no vehicles are available for selection.
 * Provides guidance to add vehicles in the garage.
 */
private struct EmptyVehiclesState: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "car")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Vehicles")
                .font(.title)
                .fontWeight(.semibold)
            
            Text("Add a vehicle in the Garage section")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

/**
 * Vehicle List Section
 *
 * Displays the list of available vehicles with selection handling.
 */
private struct VehicleListSection: View {
    let vehicles: [Vehicle]
    let selectedVehicle: Vehicle?
    let onVehicleSelected: (Vehicle) -> Void
    
    var body: some View {
        List {
            ForEach(vehicles) { vehicle in
                VehicleSelectionRowView(
                    vehicle: vehicle,
                    isSelected: selectedVehicle?.id == vehicle.id,
                    onTap: { onVehicleSelected(vehicle) }
                )
            }
        }
    }
}

/**
 * Vehicle Selection Row View
 *
 * Individual vehicle row in the selection list.
 * Shows vehicle details and selection state.
 */
private struct VehicleSelectionRowView: View {
    let vehicle: Vehicle
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading) {
                    Text(vehicle.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("\(vehicle.make) \(vehicle.model) (\(vehicle.year))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    VehicleSelectionView(viewModel: CalculatorViewModel())
}
