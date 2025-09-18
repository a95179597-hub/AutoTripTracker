import SwiftUI
import Foundation

/**
 * OnboardingViewModel
 *
 * ViewModel responsible for managing the onboarding flow state and logic.
 * Handles page navigation, completion tracking, and integration with
 * the data persistence service.
 *
 * Key Features:
 * - Page navigation management
 * - Onboarding completion tracking
 * - Integration with DataPersistenceService
 * - State management for onboarding flow
 */
class OnboardingViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Current page index in the onboarding flow
    @Published var currentPage: Int = 0
    
    /// Whether the onboarding has been completed
    @Published var isCompleted: Bool = false
    
    /// Total number of onboarding pages
    let totalPages: Int = 4
    
    // MARK: - Computed Properties
    
    /// Whether the current page is the last page
    var isLastPage: Bool {
        return currentPage == totalPages - 1
    }
    
    /// Whether the current page is the first page
    var isFirstPage: Bool {
        return currentPage == 0
    }
    
    /// Progress percentage for the onboarding flow
    var progress: Double {
        return Double(currentPage + 1) / Double(totalPages)
    }
    
    // MARK: - Navigation Methods
    
    /**
     * Advances to the next page in the onboarding flow
     */
    func nextPage() {
        if currentPage < totalPages - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage += 1
            }
        }
    }
    
    /**
     * Goes back to the previous page in the onboarding flow
     */
    func previousPage() {
        if currentPage > 0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage -= 1
            }
        }
    }
    
    /**
     * Completes the onboarding flow
     *
     * This method marks the app as launched and sets the completion state.
     * It should be called when the user finishes the onboarding process.
     */
    func completeOnboarding() {
        DataPersistenceService.markAsLaunched()
        withAnimation(.easeInOut(duration: 0.5)) {
            isCompleted = true
        }
    }
    
    /**
     * Skips the onboarding flow
     *
     * This method allows users to skip onboarding while still marking
     * the app as launched.
     */
    func skipOnboarding() {
        DataPersistenceService.markAsLaunched()
        withAnimation(.easeInOut(duration: 0.5)) {
            isCompleted = true
        }
    }
    
    // MARK: - Static Methods
    
    /**
     * Checks if onboarding should be shown
     *
     * - Returns: True if this is the first launch and onboarding should be shown
     */
    static func shouldShowOnboarding() -> Bool {
        return DataPersistenceService.isFirstLaunch()
    }
}
