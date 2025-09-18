import Foundation

/**
 * DataPersistenceService
 *
 * Centralized service for handling all data persistence operations using UserDefaults.
 * This service abstracts the data storage layer and provides a clean interface
 * for the ViewModels to interact with persistent data.
 *
 * Key Features:
 * - Type-safe data operations
 * - Centralized storage key management
 * - Error handling for data operations
 * - Support for both Vehicles and FillUps
 */
class DataPersistenceService {
    
    // MARK: - Storage Keys
    
    /// Key for storing vehicle data in UserDefaults
    private static let vehiclesKey = Constants.vehiclesKey
    
    /// Key for storing fill-up data in UserDefaults
    private static let fillUpsKey = Constants.fillUpsKey
    
    /// Key for tracking if this is the first app launch
    private static let hasLaunchedBeforeKey = Constants.hasLaunchedBeforeKey
    
    // MARK: - Vehicle Operations
    
    /**
     * Saves an array of vehicles to persistent storage
     *
     * - Parameter vehicles: Array of vehicles to save
     * - Throws: EncodingError if serialization fails
     */
    static func saveVehicles(_ vehicles: [Vehicle]) throws {
        let encoded = try JSONEncoder().encode(vehicles)
        UserDefaults.standard.set(encoded, forKey: vehiclesKey)
    }
    
    /**
     * Loads vehicles from persistent storage
     *
     * - Returns: Array of vehicles, or empty array if none found
     * - Throws: DecodingError if deserialization fails
     */
    static func loadVehicles() throws -> [Vehicle] {
        guard let data = UserDefaults.standard.data(forKey: vehiclesKey) else {
            return []
        }
        return try JSONDecoder().decode([Vehicle].self, from: data)
    }
    
    // MARK: - FillUp Operations
    
    /**
     * Saves an array of fill-ups to persistent storage
     *
     * - Parameter fillUps: Array of fill-ups to save
     * - Throws: EncodingError if serialization fails
     */
    static func saveFillUps(_ fillUps: [FillUp]) throws {
        let encoded = try JSONEncoder().encode(fillUps)
        UserDefaults.standard.set(encoded, forKey: fillUpsKey)
    }
    
    /**
     * Loads fill-ups from persistent storage
     *
     * - Returns: Array of fill-ups, or empty array if none found
     * - Throws: DecodingError if deserialization fails
     */
    static func loadFillUps() throws -> [FillUp] {
        guard let data = UserDefaults.standard.data(forKey: fillUpsKey) else {
            return []
        }
        return try JSONDecoder().decode([FillUp].self, from: data)
    }
    
    // MARK: - Utility Methods
    
    /**
     * Clears all stored data
     *
     * This method removes all vehicles and fill-ups from persistent storage.
     * Use with caution as this action cannot be undone.
     */
    static func clearAllData() {
        UserDefaults.standard.removeObject(forKey: vehiclesKey)
        UserDefaults.standard.removeObject(forKey: fillUpsKey)
    }
    
    /**
     * Checks if any data exists in storage
     *
     * - Returns: True if any vehicles or fill-ups are stored
     */
    static func hasData() -> Bool {
        return UserDefaults.standard.data(forKey: vehiclesKey) != nil ||
               UserDefaults.standard.data(forKey: fillUpsKey) != nil
    }
    
    // MARK: - First Launch Operations
    
    /**
     * Checks if this is the first app launch
     *
     * - Returns: True if this is the first launch, false otherwise
     */
    static func isFirstLaunch() -> Bool {
        return !UserDefaults.standard.bool(forKey: hasLaunchedBeforeKey)
    }
    
    /**
     * Marks that the app has been launched before
     *
     * This should be called after the user completes onboarding
     * or dismisses the onboarding screen.
     */
    static func markAsLaunched() {
        UserDefaults.standard.set(true, forKey: hasLaunchedBeforeKey)
    }
}
