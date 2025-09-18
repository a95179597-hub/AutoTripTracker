import SwiftUI

/**
 * OnboardingView
 *
 * Main onboarding view that presents a multi-page introduction to the app.
 * Uses a TabView with PageTabViewStyle to create a swipeable onboarding experience.
 *
 * Key Features:
 * - Multi-page onboarding flow
 * - Swipeable page navigation
 * - Progress indicator
 * - Skip and completion options
 * - Modern iOS design patterns
 */
struct OnboardingView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var viewModel: OnboardingViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress indicator
                progressIndicator
                
                // Page content
                TabView(selection: $viewModel.currentPage) {
                    WelcomePageView()
                        .tag(0)
                    
                    FeaturesPageView()
                        .tag(1)
                    
                    HowItWorksPageView()
                        .tag(2)
                    
                    GetStartedPageView()
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: viewModel.currentPage)
                
                // Navigation controls
                navigationControls
            }
        }
    }
    
    // MARK: - Progress Indicator
    
    private var progressIndicator: some View {
        VStack(spacing: Constants.standardSpacing) {
            HStack {
                Spacer()
                Button("Skip") {
                    viewModel.skipOnboarding()
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            .padding(.horizontal, Constants.standardPadding)
            .padding(.top, Constants.standardPadding)
            
            // Progress bar
            ProgressView(value: viewModel.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .padding(.horizontal, Constants.standardPadding)
        }
    }
    
    // MARK: - Navigation Controls
    
    private var navigationControls: some View {
        HStack {
            // Previous button
            if !viewModel.isFirstPage {
                Button(action: {
                    viewModel.previousPage()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Previous")
                    }
                    .foregroundColor(.blue)
                    .font(.subheadline)
                }
            }
            
            Spacer()
            
            // Next/Get Started button
            Button(action: {
                if viewModel.isLastPage {
                    viewModel.completeOnboarding()
                } else {
                    viewModel.nextPage()
                }
            }) {
                HStack {
                    Text(viewModel.isLastPage ? "Get Started" : "Next")
                    if !viewModel.isLastPage {
                        Image(systemName: "chevron.right")
                    }
                }
                .foregroundColor(.white)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, Constants.largeSpacing)
                .padding(.vertical, Constants.standardSpacing)
                .background(
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .fill(Color.blue)
                )
            }
        }
        .padding(.horizontal, Constants.standardPadding)
        .padding(.bottom, Constants.largeSpacing)
    }
}

// MARK: - Welcome Page

struct WelcomePageView: View {
    var body: some View {
        VStack(spacing: Constants.largeSpacing) {
            Spacer()
            
            // App icon placeholder
            Image(systemName: "fuelpump.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .padding(.bottom, Constants.standardSpacing)
            
            VStack(spacing: Constants.standardSpacing) {
                Text("Welcome to")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Text(Constants.appName)
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.primary)
            }
            
            Text("Track your fuel consumption and optimize your driving habits with our comprehensive fuel tracking solution.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, Constants.standardPadding)
            
            Spacer()
        }
        .padding(.horizontal, Constants.standardPadding)
    }
}

// MARK: - Features Page

struct FeaturesPageView: View {
    var body: some View {
        VStack(spacing: Constants.largeSpacing) {
            Spacer()
            
            VStack(spacing: Constants.standardSpacing) {
                Text("Key Features")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.primary)
                
                Text("Everything you need to track and optimize your fuel consumption")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: Constants.largeSpacing) {
                FeatureRowView(
                    icon: "car.fill",
                    title: "Vehicle Management",
                    description: "Add and manage multiple vehicles with detailed specifications"
                )
                
                FeatureRowView(
                    icon: "chart.bar.fill",
                    title: "Consumption Tracking",
                    description: "Monitor fuel efficiency with detailed statistics and charts"
                )
                
                FeatureRowView(
                    icon: "steeringwheel.arrow.trianglehead.counterclockwise.and.clockwise",
                    title: "Smart Calculator",
                    description: "Calculate fuel consumption and costs with precision"
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, Constants.standardPadding)
    }
}

// MARK: - How It Works Page

struct HowItWorksPageView: View {
    var body: some View {
        VStack(spacing: Constants.largeSpacing) {
            Spacer()
            
            VStack(spacing: Constants.standardSpacing) {
                Text("How It Works")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.primary)
                
                Text("Simple steps to start tracking your fuel consumption")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: Constants.largeSpacing) {
                StepRowView(
                    stepNumber: 1,
                    title: "Add Your Vehicle",
                    description: "Start by adding your vehicle details in the Garage"
                )
                
                StepRowView(
                    stepNumber: 2,
                    title: "Record Fill-ups",
                    description: "Log each fuel fill-up with odometer readings"
                )
                
                StepRowView(
                    stepNumber: 3,
                    title: "Track & Analyze",
                    description: "View detailed statistics and consumption trends"
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, Constants.standardPadding)
    }
}

// MARK: - Get Started Page

struct GetStartedPageView: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: Constants.largeSpacing) {
            Spacer()
            
            VStack(spacing: Constants.standardSpacing) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                Text("You're All Set!")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.primary)
                
                Text("Start tracking your fuel consumption and discover insights about your driving habits.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: Constants.standardSpacing) {
                Text("Ready to begin?")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Tap 'Get Started' to open your fuel tracking dashboard")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, Constants.standardPadding)
    }
}

// MARK: - Feature Row View

struct FeatureRowView: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: Constants.standardSpacing) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Step Row View

struct StepRowView: View {
    let stepNumber: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: Constants.standardSpacing) {
            Text("\(stepNumber)")
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Circle().fill(Color.blue))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingView()
}
