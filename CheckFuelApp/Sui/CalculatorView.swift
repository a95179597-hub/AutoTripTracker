import SwiftUI

/**
 * CalculatorView
 *
 * Main calculator screen for fuel consumption calculations.
 * This view provides an intuitive interface for calculating fuel needs
 * and costs based on distance, consumption rate, and fuel price.
 *
 * Key Features:
 * - Vehicle selection with automatic consumption rate updates
 * - Trip type selection (City/Highway/Mixed)
 * - Real-time calculation updates
 * - Input validation and error handling
 * - Results display with cost breakdown
 *
 * Architecture:
 * - Uses MVVM pattern with CalculatorViewModel
 * - Reactive UI updates through @StateObject
 * - Sheet presentation for vehicle selection
 */
struct CalculatorView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = CalculatorViewModel()
    @State private var showVehicleSelection = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VehicleSelectionSection(
                        selectedVehicle: viewModel.selectedVehicle,
                        showVehicleSelection: $showVehicleSelection
                    )
                    
                    TripTypeSelectionSection(
                        tripType: $viewModel.tripType,
                        onTripTypeChanged: viewModel.onTripTypeChanged
                    )
                    
                    InputFieldsSection(
                        distance: Binding(
                            get: { viewModel.distance == 0 ? "" : String(viewModel.distance) },
                            set: { viewModel.distance = Double($0) ?? 0 }
                        ),
                        consumption: Binding(
                            get: { viewModel.consumption == 0 ? "" : String(viewModel.consumption) },
                            set: { viewModel.consumption = Double($0) ?? 0 }
                        ),
                        fuelPrice: Binding(
                            get: { viewModel.fuelPrice == 0 ? "" : String(viewModel.fuelPrice) },
                            set: { viewModel.fuelPrice = Double($0) ?? 0 }
                        )
                    )
                    
                    CalculateButtonSection(
                        isEnabled: viewModel.hasValidInputs
                    )
                    
                    if viewModel.hasValidInputs {
            ResultsSection(
                fuelNeeded: viewModel.fuelNeeded,
                totalCost: viewModel.totalCost
            )
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .navigationTitle("Calculator")
        }
        .sheet(isPresented: $showVehicleSelection) {
            VehicleSelectionView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.loadVehicles()
        }
    }
}

// MARK: - Supporting Views

/**
 * Vehicle Selection Section
 *
 * Displays the selected vehicle or prompts to add one.
 * Handles vehicle selection state and navigation to vehicle picker.
 */
private struct VehicleSelectionSection: View {
    let selectedVehicle: Vehicle?
    @Binding var showVehicleSelection: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Vehicle")
                .font(.headline)
            
            if let vehicle = selectedVehicle {
                Button(action: { showVehicleSelection = true }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(vehicle.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("\(vehicle.make) \(vehicle.model)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Button(action: { showVehicleSelection = true }) {
                    HStack {
                        Image(systemName: "car")
                            .foregroundColor(.blue)
                        Text("Add Vehicle")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

/**
 * Trip Type Selection Section
 *
 * Provides segmented control for selecting driving conditions.
 * Updates consumption rate automatically based on selection.
 */
private struct TripTypeSelectionSection: View {
    @Binding var tripType: TripType
    let onTripTypeChanged: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trip Type")
                .font(.headline)
            
            Picker("Trip Type", selection: $tripType) {
                ForEach(TripType.allCases, id: \.self) { type in
                    Text(type.localizedName).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: tripType) { _ in
                onTripTypeChanged()
            }
        }
    }
}

/**
 * Input Fields Section
 *
 * Contains all input fields for distance, consumption, and fuel price.
 * Provides proper keyboard types and input validation.
 */
private struct InputFieldsSection: View {
    @Binding var distance: String
    @Binding var consumption: String
    @Binding var fuelPrice: String
    
    var body: some View {
        VStack(spacing: 16) {
            InputField(
                title: "Distance, km",
                placeholder: "Enter distance",
                text: $distance,
                keyboardType: .decimalPad
            )
            
            InputField(
                title: "Average Consumption, L/100km",
                placeholder: "Enter consumption",
                text: $consumption,
                keyboardType: .decimalPad
            )
            
            InputField(
                title: "Price per Liter, USD",
                placeholder: "Enter price",
                text: $fuelPrice,
                keyboardType: .decimalPad
            )
        }
    }
}

/**
 * Individual Input Field
 *
 * Reusable input field component with consistent styling.
 */
private struct InputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            TextField(placeholder, text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .keyboardType(keyboardType)
        }
    }
}

/**
 * Calculate Button Section
 *
 * Displays the calculate button with proper state management.
 */
private struct CalculateButtonSection: View {
    let isEnabled: Bool
    
    var body: some View {
        Button(action: {}) {
            Text("Calculate")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
        .disabled(!isEnabled)
    }
}

/**
 * Results Section
 *
 * Displays calculation results with proper formatting.
 */
private struct ResultsSection: View {
    let fuelNeeded: Double
    let totalCost: Double
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Results")
                .font(.title)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Fuel Needed")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(String(format: "%.1f L", fuelNeeded))
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Total Cost")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(String(format: "$%.2f", totalCost))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

// MARK: - Preview

#Preview {
    CalculatorView()
}
