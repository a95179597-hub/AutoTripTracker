import Foundation
import SwiftUI

/**
 * CalculatorViewModel
 *
 * ViewModel for the Calculator screen that handles fuel consumption calculations.
 * This ViewModel manages the calculator state, vehicle selection, trip type selection,
 * and performs real-time calculations based on user input.
 *
 * Key Features:
 * - Vehicle selection and management
 * - Trip type handling (City/Highway/Mixed)
 * - Real-time consumption calculations
 * - Data persistence integration
 * - Input validation
 */
class CalculatorViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Currently selected vehicle for calculations
    @Published var selectedVehicle: Vehicle?
    
    /// Selected trip type (City/Highway/Mixed)
    @Published var tripType: TripType = .mixed
    
    /// Distance input by user (km)
    @Published var distance: Double = 0
    
    /// Fuel consumption rate (L/100km)
    @Published var consumption: Double = 0
    
    /// Fuel price per liter (USD)
    @Published var fuelPrice: Double = 0
    
    /// Available vehicles for selection
    @Published var vehicles: [Vehicle] = []
    
    // MARK: - Computed Properties
    
    /**
     * Calculates fuel needed for the trip based on distance and consumption rate
     *
     * - Returns: Fuel needed in liters
     */
    var fuelNeeded: Double {
        guard distance > 0 && consumption > 0 else { return 0 }
        return (distance * consumption) / 100
    }
    
    /**
     * Calculates total cost of fuel needed
     *
     * - Returns: Total cost in USD
     */
    var totalCost: Double {
        return fuelNeeded * fuelPrice
    }
    
    /**
     * Validates if all required inputs are provided
     *
     * - Returns: True if all inputs are valid for calculation
     */
    var hasValidInputs: Bool {
        return distance > 0 && consumption > 0 && fuelPrice > 0
    }
    
    /**
     * Returns the appropriate consumption rate based on selected vehicle and trip type
     *
     * - Returns: Consumption rate in L/100km
     */
    var selectedConsumption: Double {
        guard let vehicle = selectedVehicle else { return consumption }
        
        switch tripType {
        case .city:
            return vehicle.consumptionCity
        case .highway:
            return vehicle.consumptionHighway
        case .mixed:
            return vehicle.consumptionMixed
        }
    }
    
    // MARK: - Initialization
    
    /**
     * Initialize the ViewModel and load existing data
     */
    init() {
        loadVehicles()
    }
    
    // MARK: - Public Methods
    
    /**
     * Selects a vehicle and updates consumption rate
     *
     * - Parameter vehicle: The vehicle to select
     */
    func selectVehicle(_ vehicle: Vehicle) {
        selectedVehicle = vehicle
        updateConsumptionFromVehicle()
    }
    
    /**
     * Updates trip type and recalculates consumption
     *
     * - Parameter newType: The new trip type to set
     */
    func updateTripType(_ newType: TripType) {
        tripType = newType
        updateConsumptionFromVehicle()
    }
    
    /**
     * Handles trip type change and updates consumption
     */
    func onTripTypeChanged() {
        updateConsumptionFromVehicle()
    }
    
    /**
     * Loads vehicles from persistent storage
     */
    func loadVehicles() {
        do {
            vehicles = try DataPersistenceService.loadVehicles()
            if selectedVehicle == nil, let firstVehicle = vehicles.first {
                selectedVehicle = firstVehicle
                updateConsumptionFromVehicle()
            }
        } catch {
            print("Error loading vehicles: \(error)")
            vehicles = []
        }
    }
    
    // MARK: - Private Methods
    
    /**
     * Updates consumption rate based on selected vehicle and trip type
     */
    private func updateConsumptionFromVehicle() {
        if let vehicle = selectedVehicle {
            consumption = selectedConsumption
        }
    }
}
