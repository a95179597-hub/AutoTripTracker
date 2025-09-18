import Foundation
import SwiftUI

/**
 * GarageViewModel
 *
 * ViewModel for the Garage screen that manages vehicle data and operations.
 * This ViewModel handles vehicle CRUD operations, data persistence, and
 * provides the interface for vehicle management throughout the app.
 *
 * Key Features:
 * - Vehicle management (add, delete, update)
 * - Data persistence integration
 * - Vehicle selection state management
 * - Input validation
 */
class GarageViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// List of all vehicles in the garage
    @Published var vehicles: [Vehicle] = []
    
    /// Controls the display of the add vehicle sheet
    @Published var showAddVehicle = false
    
    // MARK: - Initialization
    
    /**
     * Initialize the ViewModel and load existing data
     */
    init() {
        loadVehicles()
    }
    
    // MARK: - Public Methods
    
    /**
     * Adds a new vehicle to the garage
     *
     * - Parameter vehicle: The vehicle to add
     */
    func addVehicle(_ vehicle: Vehicle) {
        vehicles.append(vehicle)
        saveVehicles()
    }
    
    /**
     * Deletes vehicles at the specified indices
     *
     * - Parameter offsets: IndexSet containing indices to delete
     */
    func deleteVehicle(at offsets: IndexSet) {
        vehicles.remove(atOffsets: offsets)
        saveVehicles()
    }
    
    /**
     * Updates an existing vehicle
     *
     * - Parameter vehicle: The updated vehicle
     */
    func updateVehicle(_ vehicle: Vehicle) {
        if let index = vehicles.firstIndex(where: { $0.id == vehicle.id }) {
            vehicles[index] = vehicle
            saveVehicles()
        }
    }
    
    /**
     * Loads vehicles from persistent storage
     */
    func loadVehicles() {
        do {
            vehicles = try DataPersistenceService.loadVehicles()
        } catch {
            print("Error loading vehicles: \(error)")
            vehicles = []
        }
    }
    
    // MARK: - Private Methods
    
    /**
     * Saves vehicles to persistent storage
     */
    private func saveVehicles() {
        do {
            try DataPersistenceService.saveVehicles(vehicles)
        } catch {
            print("Error saving vehicles: \(error)")
        }
    }
}
