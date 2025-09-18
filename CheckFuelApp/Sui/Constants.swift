import Foundation

/**
 * Constants
 *
 * Centralized constants used throughout the application.
 * This file contains all string literals, numeric constants,
 * and configuration values to maintain consistency and
 * enable easy updates.
 *
 * Key Features:
 * - Centralized string constants
 * - Numeric constants for calculations
 * - UserDefaults keys
 * - UI configuration values
 */
struct Constants {
    
    // MARK: - UserDefaults Keys
    
    /// Key for storing vehicle data in UserDefaults
    static let vehiclesKey = "SavedVehicles"
    
    /// Key for storing fill-up data in UserDefaults
    static let fillUpsKey = "SavedFillUps"
    
    /// Key for tracking if this is the first app launch
    static let hasLaunchedBeforeKey = "HasLaunchedBefore"
    
    // MARK: - UI Constants
    
    /// Standard corner radius for UI elements
    static let cornerRadius: CGFloat = 8
    
    /// Standard padding for UI elements
    static let standardPadding: CGFloat = 16
    
    /// Standard spacing between UI elements
    static let standardSpacing: CGFloat = 12
    
    /// Large spacing for major UI sections
    static let largeSpacing: CGFloat = 24
    
    // MARK: - Chart Constants
    
    /// Maximum height for chart bars
    static let maxChartHeight: CGFloat = 200
    
    /// Bar width for chart elements
    static let chartBarWidth: CGFloat = 20
    
    /// Spacing between chart bars
    static let chartBarSpacing: CGFloat = 8
    
    // MARK: - Validation Constants
    
    /// Minimum valid distance for calculations
    static let minDistance: Double = 0.1
    
    /// Minimum valid consumption rate
    static let minConsumption: Double = 0.1
    
    /// Minimum valid fuel price
    static let minFuelPrice: Double = 0.01
    
    /// Minimum valid odometer reading
    static let minOdometer: Double = 0.1
    
    /// Minimum valid fuel volume
    static let minVolume: Double = 0.1
    
    // MARK: - String Constants
    
    /// App name
    static let appName = "Fuel Track"
    
    /// Default currency symbol
    static let currencySymbol = "$"
    
    /// Default distance unit
    static let distanceUnit = "km"
    
    /// Default volume unit
    static let volumeUnit = "L"
    
    /// Default consumption unit
    static let consumptionUnit = "L/100km"
    
    // MARK: - Error Messages
    
    /// Generic error message for data loading
    static let dataLoadingError = "Error loading data"
    
    /// Generic error message for data saving
    static let dataSavingError = "Error saving data"
    
    /// Error message for invalid input
    static let invalidInputError = "Please enter valid values"
    
    /// Error message for missing vehicle selection
    static let missingVehicleError = "Please select a vehicle"
}
