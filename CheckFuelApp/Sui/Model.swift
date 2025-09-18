import Foundation

/**
 * Vehicle Model
 *
 * Represents a vehicle in the garage with consumption data for different driving conditions.
 * This model follows the MVVM pattern and supports data persistence through Codable conformance.
 *
 * Key Features:
 * - Supports city, highway, and mixed driving consumption rates
 * - Backward compatible with average consumption calculation
 * - Conforms to Identifiable for SwiftUI list binding
 * - Conforms to Hashable for Picker tag support
 * - Conforms to Codable for UserDefaults persistence
 */
struct Vehicle: Identifiable, Codable, Hashable {
    // MARK: - Properties
    
    /// Unique identifier for the vehicle
    let id = UUID()
    
    /// Display name for the vehicle (e.g., "My Honda Civic")
    var name: String
    
    /// Vehicle manufacturer (e.g., "Honda")
    var make: String
    
    /// Vehicle model (e.g., "Civic")
    var model: String
    
    /// Manufacturing year
    var year: String
    
    /// Fuel consumption in city driving conditions (L/100km)
    var consumptionCity: Double
    
    /// Fuel consumption in highway driving conditions (L/100km)
    var consumptionHighway: Double
    
    /// Fuel consumption in mixed driving conditions (L/100km)
    var consumptionMixed: Double
    
    // MARK: - Initialization
    
    /**
     * Initialize a new vehicle with consumption data
     *
     * - Parameters:
     *   - name: Display name for the vehicle
     *   - make: Vehicle manufacturer
     *   - model: Vehicle model
     *   - year: Manufacturing year
     *   - consumptionCity: City driving consumption (L/100km)
     *   - consumptionHighway: Highway driving consumption (L/100km)
     *   - consumptionMixed: Mixed driving consumption (L/100km)
     */
    init(name: String, make: String, model: String, year: String,
         consumptionCity: Double = 0.0, consumptionHighway: Double = 0.0, consumptionMixed: Double = 0.0) {
        self.name = name
        self.make = make
        self.model = model
        self.year = year
        self.consumptionCity = consumptionCity
        self.consumptionHighway = consumptionHighway
        self.consumptionMixed = consumptionMixed
    }
    
    // MARK: - Computed Properties
    
    /**
     * Calculates average consumption for backward compatibility
     *
     * Returns the mixed consumption if available, otherwise calculates
     * the average of city and highway consumption.
     *
     * - Returns: Average fuel consumption in L/100km
     */
    var averageConsumption: Double {
        return consumptionMixed > 0 ? consumptionMixed : (consumptionCity + consumptionHighway) / 2
    }
}

enum TripType: String, CaseIterable, Codable {
    // MARK: - Cases
    
    /// City driving conditions (stop-and-go traffic, traffic lights)
    case city = "City"
    
    /// Highway driving conditions (steady speed, minimal stops)
    case highway = "Highway"
    
    /// Mixed driving conditions (combination of city and highway)
    case mixed = "Mixed"
    
    // MARK: - Computed Properties
    
    /**
     * Returns the localized name for display in UI
     *
     * Currently returns the raw value, but can be extended
     * to support multiple languages in the future.
     *
     * - Returns: Localized string for the trip type
     */
    var localizedName: String {
        return self.rawValue
    }
}


struct FillUp: Identifiable, Codable, Hashable {
    // MARK: - Properties
    
    /// Unique identifier for the fill-up record
    let id = UUID()
    
    /// Reference to the vehicle this fill-up belongs to
    let vehicleId: UUID
    
    /// Date when the fill-up occurred
    let date: Date
    
    /// Odometer reading at the time of fill-up (km)
    let odometer: Double
    
    /// Volume of fuel added (liters)
    let volume: Double
    
    /// Price per liter at the time of fill-up (USD)
    let pricePerLiter: Double
    
    /// Total cost of the fill-up (USD)
    let totalCost: Double
    
    /// Whether this was a full tank fill-up
    let isFullTank: Bool
    
    /// Calculated real consumption for this fill-up (L/100km)
    let realConsumption: Double
    
    // MARK: - Initialization
    
    /**
     * Initialize a new fill-up record
     *
     * - Parameters:
     *   - vehicleId: ID of the vehicle this fill-up belongs to
     *   - date: Date of the fill-up (defaults to current date)
     *   - odometer: Odometer reading at fill-up time
     *   - volume: Volume of fuel added
     *   - pricePerLiter: Price per liter of fuel
     *   - isFullTank: Whether this was a full tank fill-up
     *   - realConsumption: Pre-calculated real consumption
     */
    init(vehicleId: UUID, date: Date = Date(), odometer: Double, volume: Double,
         pricePerLiter: Double, isFullTank: Bool = true, realConsumption: Double = 0.0) {
        self.vehicleId = vehicleId
        self.date = date
        self.odometer = odometer
        self.volume = volume
        self.pricePerLiter = pricePerLiter
        self.totalCost = volume * pricePerLiter
        self.isFullTank = isFullTank
        self.realConsumption = realConsumption
    }
    
    // MARK: - Static Methods
    
    /**
     * Calculates real consumption based on previous fill-up
     *
     * This method implements the core consumption calculation logic:
     * Real Consumption = (Fuel Volume / Distance Traveled) * 100
     *
     * - Parameters:
     *   - currentFillUp: The current fill-up record
     *   - previousFillUp: The previous fill-up record for distance calculation
     *
     * - Returns: Real consumption in L/100km, or 0.0 if calculation is not possible
     */
    static func calculateRealConsumption(currentFillUp: FillUp, previousFillUp: FillUp?) -> Double {
        guard let previous = previousFillUp,
              currentFillUp.odometer > previous.odometer,
              currentFillUp.isFullTank else {
            return 0.0
        }
        
        let distance = currentFillUp.odometer - previous.odometer
        return (currentFillUp.volume / distance) * 100
    }
}
