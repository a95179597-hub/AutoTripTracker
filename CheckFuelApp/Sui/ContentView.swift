import SwiftUI
import Combine

struct ContentView: View {
    
    // MARK: - State
    
    @State private var showOnboarding = false
    @State private var isAppReady = false
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if isAppReady {
                if showOnboarding {
                    OnboardingView()
                        .environmentObject(onboardingViewModel)
                        .onReceive(onboardingViewModel.$isCompleted) { isCompleted in
                            if isCompleted {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showOnboarding = false
                                }
                            }
                        }
                } else {
                    MainTabView()
                }
            } else {
                // Loading state while checking first launch status
                loadingView
            }
        }
        .onAppear {
            checkFirstLaunch()
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: Constants.standardSpacing) {
            Image(systemName: "fuelpump.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text(Constants.appName)
                .font(.title)
                .fontWeight(.bold)
            
            ProgressView()
                .scaleEffect(1.2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Private Methods
    
    /**
     * Checks if this is the first app launch and sets the appropriate state
     */
    private func checkFirstLaunch() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showOnboarding = OnboardingViewModel.shouldShowOnboarding()
                isAppReady = true
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
