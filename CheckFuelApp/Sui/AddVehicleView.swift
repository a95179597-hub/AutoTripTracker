import SwiftUI

/**
 * AddVehicleView
 *
 * Modal view for adding new vehicles to the garage.
 * This view provides a form interface for entering vehicle information
 * and consumption rates for different driving conditions.
 *
 * Key Features:
 * - Form-based input for vehicle details
 * - Consumption rate input for city, highway, and mixed driving
 * - Input validation and error handling
 * - Save/cancel functionality
 * - Proper keyboard types for numeric inputs
 *
 * Architecture:
 * - Uses @ObservedObject for view model binding
 * - Sheet presentation from parent view
 * - Form-based layout with sections
 */
struct AddVehicleView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: GarageViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var make = ""
    @State private var model = ""
    @State private var year = ""
    @State private var consumptionCity = 0.0
    @State private var consumptionHighway = 0.0
    @State private var consumptionMixed = 0.0
    
    // MARK: - Computed Properties
    
    /**
     * Validates if all required fields are filled
     *
     * - Returns: True if all required fields have values
     */
    private var isFormValid: Bool {
        return !name.isEmpty && !make.isEmpty && !model.isEmpty && !year.isEmpty
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            Form {
                VehicleInformationSection(
                    name: $name,
                    make: $make,
                    model: $model,
                    year: $year
                )
                
                FuelConsumptionSection(
                    consumptionCity: $consumptionCity,
                    consumptionHighway: $consumptionHighway,
                    consumptionMixed: $consumptionMixed
                )
            }
            .navigationTitle("Add Vehicle")
            .navigationBarItems(
                leading: cancelButton,
                trailing: saveButton
            )
        }
    }
    
    // MARK: - Button Views
    
    /**
     * Cancel button for dismissing the view
     */
    private var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    /**
     * Save button for creating the vehicle
     */
    private var saveButton: some View {
        Button("Save") {
            saveVehicle()
        }
        .disabled(!isFormValid)
    }
    
    // MARK: - Private Methods
    
    /**
     * Creates and saves the new vehicle
     */
    private func saveVehicle() {
        let vehicle = Vehicle(
            name: name,
            make: make,
            model: model,
            year: year,
            consumptionCity: consumptionCity,
            consumptionHighway: consumptionHighway,
            consumptionMixed: consumptionMixed
        )
        
        viewModel.addVehicle(vehicle)
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Supporting Views

/**
 * Vehicle Information Section
 *
 * Form section for basic vehicle information.
 */
private struct VehicleInformationSection: View {
    @Binding var name: String
    @Binding var make: String
    @Binding var model: String
    @Binding var year: String
    
    var body: some View {
        Section(header: Text("Vehicle Information")) {
            TextField("Vehicle Name", text: $name)
            TextField("Make", text: $make)
            TextField("Model", text: $model)
            TextField("Year", text: $year)
                .keyboardType(.numberPad)
        }
    }
}

/**
 * Fuel Consumption Section
 *
 * Form section for consumption rate inputs.
 */
private struct FuelConsumptionSection: View {
    @Binding var consumptionCity: Double
    @Binding var consumptionHighway: Double
    @Binding var consumptionMixed: Double
    
    var body: some View {
        Section(header: Text("Fuel Consumption")) {
            ConsumptionInputRow(
                title: "City",
                value: $consumptionCity
            )
            
            ConsumptionInputRow(
                title: "Highway",
                value: $consumptionHighway
            )
            
            ConsumptionInputRow(
                title: "Mixed",
                value: $consumptionMixed
            )
        }
    }
}

/**
 * Consumption Input Row
 *
 * Individual row for consumption rate input.
 */
private struct ConsumptionInputRow: View {
    let title: String
    @Binding var value: Double
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            TextField("0.0", text: Binding(
                get: { value == 0 ? "" : String(value) },
                set: { value = Double($0) ?? 0 }
            ))
            .keyboardType(.decimalPad)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 80)
            Text("L/100km")
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    AddVehicleView(viewModel: GarageViewModel())
}
