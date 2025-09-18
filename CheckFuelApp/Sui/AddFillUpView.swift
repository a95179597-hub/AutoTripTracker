import SwiftUI

/**
 * AddFillUpView
 *
 * Modal view for adding new fuel fill-up records.
 * This view provides a comprehensive form for entering fill-up details
 * including vehicle selection, date, odometer, volume, and pricing.
 *
 * Key Features:
 * - Vehicle selection from available vehicles
 * - Date picker for fill-up date
 * - Odometer and volume input
 * - Price per liter input with automatic total calculation
 * - Full tank toggle for accurate consumption calculation
 * - Input validation and error handling
 *
 * Architecture:
 * - Uses @ObservedObject for view model binding
 * - Sheet presentation from parent view
 * - Form-based layout with sections
 * - Computed properties for complex bindings
 */
struct AddFillUpView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: StatisticsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedVehicle: Vehicle?
    @State private var date = Date()
    @State private var odometer = 0.0
    @State private var volume = 0.0
    @State private var pricePerLiter = 0.0
    @State private var isFullTank = true
    
    // MARK: - Computed Properties
    
    /**
     * Calculates total cost based on volume and price per liter
     *
     * - Returns: Total cost in USD
     */
    var totalCost: Double {
        return volume * pricePerLiter
    }
    
    /**
     * Validates if all required fields are filled
     *
     * - Returns: True if all required fields have values
     */
    private var isSaveDisabled: Bool {
        return selectedVehicle == nil || odometer == 0 || volume == 0 || pricePerLiter == 0
    }
    
    // MARK: - Computed Bindings
    
    /**
     * Binding for odometer input with proper string conversion
     */
    private var odometerBinding: Binding<String> {
        Binding(
            get: { odometer == 0 ? "" : String(odometer) },
            set: { odometer = Double($0) ?? 0 }
        )
    }
    
    /**
     * Binding for volume input with proper string conversion
     */
    private var volumeBinding: Binding<String> {
        Binding(
            get: { volume == 0 ? "" : String(volume) },
            set: { volume = Double($0) ?? 0 }
        )
    }
    
    /**
     * Binding for price input with proper string conversion
     */
    private var priceBinding: Binding<String> {
        Binding(
            get: { pricePerLiter == 0 ? "" : String(pricePerLiter) },
            set: { pricePerLiter = Double($0) ?? 0 }
        )
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            Form {
                VehicleSelectionSection(selectedVehicle: $selectedVehicle, vehicles: viewModel.vehicles)
                
                FillUpDateSection(date: $date)
                
                OdometerVolumeSection(
                    odometer: odometerBinding,
                    volume: volumeBinding,
                    isFullTank: $isFullTank
                )
                
                PriceSection(
                    pricePerLiter: priceBinding,
                    totalCost: totalCost
                )
            }
            .navigationTitle("Add Fill-up")
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
     * Save button for creating the fill-up record
     */
    private var saveButton: some View {
        Button("Save") {
            saveFillUp()
        }
        .disabled(isSaveDisabled)
    }
    
    // MARK: - Private Methods
    
    /**
     * Creates and saves the new fill-up record
     */
    private func saveFillUp() {
        guard let vehicle = selectedVehicle else { return }
        
        let fillUp = FillUp(
            vehicleId: vehicle.id,
            date: date,
            odometer: odometer,
            volume: volume,
            pricePerLiter: pricePerLiter,
            isFullTank: isFullTank
        )
        
        viewModel.addFillUp(fillUp)
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Supporting Views

/**
 * Vehicle Selection Section
 *
 * Form section for selecting the vehicle for the fill-up.
 */
private struct VehicleSelectionSection: View {
    @Binding var selectedVehicle: Vehicle?
    let vehicles: [Vehicle]
    
    var body: some View {
        Section(header: Text("Vehicle")) {
            Picker("Vehicle", selection: $selectedVehicle) {
                ForEach(vehicles) { vehicle in
                    Text(vehicle.name).tag(vehicle as Vehicle?)
                }
            }
        }
    }
}

/**
 * Fill-up Date Section
 *
 * Form section for selecting the fill-up date.
 */
private struct FillUpDateSection: View {
    @Binding var date: Date
    
    var body: some View {
        Section(header: Text("Fill-up Date")) {
            DatePicker("Date", selection: $date, displayedComponents: .date)
        }
    }
}

/**
 * Odometer and Volume Section
 *
 * Form section for entering odometer reading and fuel volume.
 */
private struct OdometerVolumeSection: View {
    @Binding var odometer: String
    @Binding var volume: String
    @Binding var isFullTank: Bool
    
    var body: some View {
        Section(header: Text("Odometer & Volume")) {
            HStack {
                Text("Odometer, km")
                Spacer()
                TextField("0", text: $odometer)
                    .keyboardType(.decimalPad)
                    .frame(width: 100)
            }
            
            HStack {
                Text("Volume, L")
                Spacer()
                TextField("0", text: $volume)
                    .keyboardType(.decimalPad)
                    .frame(width: 100)
            }
            
            Toggle("Full Tank", isOn: $isFullTank)
        }
    }
}

/**
 * Price Section
 *
 * Form section for entering fuel price and displaying total cost.
 */
private struct PriceSection: View {
    @Binding var pricePerLiter: String
    let totalCost: Double
    
    var body: some View {
        Section(header: Text("Price")) {
            HStack {
                Text("Price per Liter, USD")
                Spacer()
                TextField("0", text: $pricePerLiter)
                    .keyboardType(.decimalPad)
                    .frame(width: 100)
            }
            
            HStack {
                Text("Total Cost")
                Spacer()
                Text(String(format: "$%.2f", totalCost))
                    .fontWeight(.medium)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    AddFillUpView(viewModel: StatisticsViewModel())
}
