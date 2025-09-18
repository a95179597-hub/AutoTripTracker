import SwiftUI

/**
 * GarageView
 *
 * Main garage screen for managing vehicles.
 * This view provides an interface for viewing, adding, and managing
 * vehicles in the user's garage with detailed consumption information.
 *
 * Key Features:
 * - Displays list of vehicles with consumption details
 * - Add new vehicles functionality
 * - Delete vehicles with swipe gestures
 * - Empty state handling
 * - Navigation to add vehicle screen
 *
 * Architecture:
 * - Uses MVVM pattern with GarageViewModel
 * - Sheet presentation for add vehicle
 * - List with swipe-to-delete functionality
 */
struct GarageView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = GarageViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.vehicles.isEmpty {
                    EmptyGarageState(
                        onAddVehicle: { viewModel.showAddVehicle = true }
                    )
                } else {
                    VehicleListSection(
                        vehicles: viewModel.vehicles,
                        onDelete: viewModel.deleteVehicle
                    )
                }
            }
            .navigationTitle("Garage")
            .navigationBarItems(
                trailing: Button("Add") {
                    viewModel.showAddVehicle = true
                }
            )
            .sheet(isPresented: $viewModel.showAddVehicle) {
                AddVehicleView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Supporting Views

/**
 * Empty Garage State
 *
 * Displays when no vehicles are in the garage.
 * Provides guidance and action to add the first vehicle.
 */
private struct EmptyGarageState: View {
    let onAddVehicle: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "car")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Vehicles")
                .font(.title)
                .fontWeight(.semibold)
            
            Text("Add your first vehicle to track fuel consumption")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Add Vehicle", action: onAddVehicle)
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
 * Vehicle List Section
 *
 * Displays the list of vehicles with delete functionality.
 */
private struct VehicleListSection: View {
    let vehicles: [Vehicle]
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        List {
            ForEach(vehicles) { vehicle in
                VehicleRowView(vehicle: vehicle)
            }
            .onDelete(perform: onDelete)
        }
    }
}

/**
 * Vehicle Row View
 *
 * Individual vehicle row displaying vehicle information and consumption rates.
 * Shows detailed consumption data for city, highway, and mixed driving.
 */
struct VehicleRowView: View {
    let vehicle: Vehicle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VehicleHeaderSection(vehicle: vehicle)
            VehicleConsumptionSection(vehicle: vehicle)
        }
        .padding(.vertical, 4)
    }
}

/**
 * Vehicle Header Section
 *
 * Displays basic vehicle information (name, make, model, year).
 */
private struct VehicleHeaderSection: View {
    let vehicle: Vehicle
    
    var body: some View {
        HStack {
            Text(vehicle.name)
                .font(.headline)
            Spacer()
            Text(vehicle.year)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        
        HStack {
            Text("\(vehicle.make) \(vehicle.model)")
                .font(.subheadline)
            Spacer()
        }
    }
}

/**
 * Vehicle Consumption Section
 *
 * Displays consumption rates for different driving conditions.
 */
private struct VehicleConsumptionSection: View {
    let vehicle: Vehicle
    
    var body: some View {
        HStack(spacing: 16) {
            ConsumptionRateView(
                title: "City",
                value: vehicle.consumptionCity
            )
            
            ConsumptionRateView(
                title: "Highway",
                value: vehicle.consumptionHighway
            )
            
            ConsumptionRateView(
                title: "Mixed",
                value: vehicle.consumptionMixed
            )
            
            Spacer()
        }
    }
}

/**
 * Consumption Rate View
 *
 * Individual consumption rate display component.
 */
private struct ConsumptionRateView: View {
    let title: String
    let value: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(String(format: "%.1f", value))
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Preview

#Preview {
    GarageView()
}
