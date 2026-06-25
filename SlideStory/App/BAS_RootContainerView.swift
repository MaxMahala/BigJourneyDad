import SwiftUI

struct BAS_RootContainerView: View {
    @EnvironmentObject var router: BAS_AppRouter

    var body: some View {
        ZStack {
            switch router.currentScreen {
            case .splash:
                BAS_SplashView()
                    .transition(.opacity)
            case .onboarding:
                BAS_OnboardingContainerView()
                    .transition(.opacity)
            case .main:
                BAS_MainTabContainerView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: router.currentScreen)
    }
}
