import Foundation

/**
 * ConsumptionCalculationService
 *
 * Service responsible for all fuel consumption calculations and statistics.
 * This service encapsulates the business logic for calculating various
 * consumption metrics and provides a clean interface for the ViewModels.
 *
 * Key Features:
 * - Real consumption calculations
 * - Statistical analysis of consumption data
 * - Monthly cost calculations
 * - Price trend analysis
 */
class ConsumptionCalculationService {
    
    // MARK: - Real Consumption Calculations
    
    /**
     * Calculates real consumption history from fill-up data
     *
     * This method processes a sorted array of fill-ups and calculates
     * the real consumption for each full tank fill-up based on the
     * previous fill-up's odometer reading.
     *
     * - Parameter fillUps: Array of fill-ups sorted by date
     * - Returns: Array of tuples containing date and real consumption
     */
    static func calculateRealConsumptionHistory(from fillUps: [FillUp]) -> [(Date, Double)] {
        let sortedFillUps = fillUps.sorted { $0.date < $1.date }
        var history: [(Date, Double)] = []
        
        // Avoid invalid range when there are fewer than 2 fill-ups
        guard sortedFillUps.count >= 2 else { return history }
        
        for i in 1..<sortedFillUps.count {
            let current = sortedFillUps[i]
            let previous = sortedFillUps[i-1]
            
            if current.isFullTank && current.odometer > previous.odometer {
                let consumption = FillUp.calculateRealConsumption(currentFillUp: current, previousFillUp: previous)
                if consumption > 0 {
                    history.append((current.date, consumption))
                }
            }
        }
        
        return history
    }
    
    // MARK: - Statistical Calculations
    
    /**
     * Calculates total distance traveled based on fill-up data
     *
     * - Parameter fillUps: Array of fill-ups
     * - Returns: Total distance in kilometers
     */
    static func calculateTotalDistance(from fillUps: [FillUp]) -> Double {
        guard fillUps.count >= 2 else { return 0 }
        let sortedFillUps = fillUps.sorted { $0.odometer < $1.odometer }
        return (sortedFillUps.last?.odometer ?? 0) - (sortedFillUps.first?.odometer ?? 0)
    }
    
    /**
     * Calculates total fuel consumed
     *
     * - Parameter fillUps: Array of fill-ups
     * - Returns: Total fuel volume in liters
     */
    static func calculateTotalFuel(from fillUps: [FillUp]) -> Double {
        return fillUps.reduce(0) { $0 + $1.volume }
    }
    
    /**
     * Calculates total cost of all fill-ups
     *
     * - Parameter fillUps: Array of fill-ups
     * - Returns: Total cost in USD
     */
    static func calculateTotalCost(from fillUps: [FillUp]) -> Double {
        return fillUps.reduce(0) { $0 + $1.totalCost }
    }
    
    /**
     * Calculates average consumption across all fill-ups
     *
     * - Parameter fillUps: Array of fill-ups
     * - Returns: Average consumption in L/100km
     */
    static func calculateAverageConsumption(from fillUps: [FillUp]) -> Double {
        let totalDistance = calculateTotalDistance(from: fillUps)
        let totalFuel = calculateTotalFuel(from: fillUps)
        
        guard totalDistance > 0 else { return 0 }
        return (totalFuel / totalDistance) * 100
    }
    
    // MARK: - Monthly Analysis
    
    /**
     * Groups fill-ups by month and calculates monthly costs
     *
     * - Parameter fillUps: Array of fill-ups
     * - Returns: Array of tuples containing month string and total cost
     */
    static func calculateMonthlyCosts(from fillUps: [FillUp]) -> [(String, Double)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: fillUps) { fillUp in
            let components = calendar.dateComponents([.year, .month], from: fillUp.date)
            return "\(components.year ?? 0)-\(String(format: "%02d", components.month ?? 0))"
        }
        
        return grouped.map { (month, fillUps) in
            (month, fillUps.reduce(0) { $0 + $1.totalCost })
        }.sorted { $0.0 < $1.0 }
    }
    
    /**
     * Extracts price history from fill-ups
     *
     * - Parameter fillUps: Array of fill-ups
     * - Returns: Array of tuples containing date and price per liter
     */
    static func extractPriceHistory(from fillUps: [FillUp]) -> [(Date, Double)] {
        return fillUps.sorted { $0.date < $1.date }.map { ($0.date, $0.pricePerLiter) }
    }
}
