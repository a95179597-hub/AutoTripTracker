import Foundation
import SwiftUI

class StatisticsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// List of all fill-up records
    @Published var fillUps: [FillUp] = []
    
    /// List of all vehicles for fill-up creation
    @Published var vehicles: [Vehicle] = []
    
    // MARK: - Computed Properties
    
    /**
     * Calculates total distance traveled using ConsumptionCalculationService
     *
     * - Returns: Total distance in kilometers
     */
    var totalDistance: Double {
        return ConsumptionCalculationService.calculateTotalDistance(from: fillUps)
    }
    
    /**
     * Calculates total fuel consumed using ConsumptionCalculationService
     *
     * - Returns: Total fuel volume in liters
     */
    var totalFuel: Double {
        return ConsumptionCalculationService.calculateTotalFuel(from: fillUps)
    }
    
    /**
     * Calculates total cost of all fill-ups using ConsumptionCalculationService
     *
     * - Returns: Total cost in USD
     */
    var totalCost: Double {
        return ConsumptionCalculationService.calculateTotalCost(from: fillUps)
    }
    
    /**
     * Calculates average consumption using ConsumptionCalculationService
     *
     * - Returns: Average consumption in L/100km
     */
    var averageConsumption: Double {
        return ConsumptionCalculationService.calculateAverageConsumption(from: fillUps)
    }
    
    /**
     * Calculates real consumption history using ConsumptionCalculationService
     *
     * - Returns: Array of tuples containing date and real consumption
     */
    var realConsumptionHistory: [(Date, Double)] {
        return ConsumptionCalculationService.calculateRealConsumptionHistory(from: fillUps)
    }
    
    /**
     * Calculates monthly costs using ConsumptionCalculationService
     *
     * - Returns: Array of tuples containing month string and total cost
     */
    var monthlyCosts: [(String, Double)] {
        return ConsumptionCalculationService.calculateMonthlyCosts(from: fillUps)
    }
    
    /**
     * Extracts price history using ConsumptionCalculationService
     *
     * - Returns: Array of tuples containing date and price per liter
     */
    var priceHistory: [(Date, Double)] {
        return ConsumptionCalculationService.extractPriceHistory(from: fillUps)
    }
    
    // MARK: - Initialization
    
    /**
     * Initialize the ViewModel and load existing data
     */
    init() {
        loadData()
    }
    
    // MARK: - Public Methods
    
    /**
     * Adds a new fill-up record
     *
     * - Parameter fillUp: The fill-up to add
     */
    func addFillUp(_ fillUp: FillUp) {
        fillUps.append(fillUp)
        saveFillUps()
    }
    
    /**
     * Deletes fill-ups at the specified indices
     *
     * - Parameter offsets: IndexSet containing indices to delete
     */
    func deleteFillUp(at offsets: IndexSet) {
        fillUps.remove(atOffsets: offsets)
        saveFillUps()
    }
    
    /**
     * Updates an existing fill-up record
     *
     * - Parameter fillUp: The updated fill-up
     */
    func updateFillUp(_ fillUp: FillUp) {
        if let index = fillUps.firstIndex(where: { $0.id == fillUp.id }) {
            fillUps[index] = fillUp
            saveFillUps()
        }
    }
    
    /**
     * Loads all data from persistent storage
     */
    func loadData() {
        loadFillUps()
        loadVehicles()
    }
    
    // MARK: - Private Methods
    
    /**
     * Loads fill-ups from persistent storage
     */
    private func loadFillUps() {
        do {
            fillUps = try DataPersistenceService.loadFillUps()
        } catch {
            print("Error loading fill-ups: \(error)")
            fillUps = []
        }
    }
    
    /**
     * Loads vehicles from persistent storage
     */
    private func loadVehicles() {
        do {
            vehicles = try DataPersistenceService.loadVehicles()
        } catch {
            print("Error loading vehicles: \(error)")
            vehicles = []
        }
    }
    
    /**
     * Saves fill-ups to persistent storage
     */
    private func saveFillUps() {
        do {
            try DataPersistenceService.saveFillUps(fillUps)
        } catch {
            print("Error saving fill-ups: \(error)")
        }
    }
}
