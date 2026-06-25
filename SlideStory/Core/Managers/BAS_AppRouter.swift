import SwiftUI
import Combine

enum BAS_RootScreen {
    case splash
    case onboarding
    case main
}

final class BAS_AppRouter: ObservableObject {
    @Published var currentScreen: BAS_RootScreen = .splash
    @Published var selectedTab: BAS_MainTab = .gallery
    @Published var presentedSheet: BAS_SheetDestination?
    @Published var activeProject: BAS_SliderProject?

    @AppStorage("bas_has_completed_onboarding") private var hasCompletedOnboarding: Bool = false

    func finishSplash() {
        withAnimation(.easeInOut(duration: 0.45)) {
            currentScreen = hasCompletedOnboarding ? .main : .onboarding
        }
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        withAnimation(.easeInOut(duration: 0.5)) {
            currentScreen = .main
        }
    }

    func openCreationFlow() {
        presentedSheet = .createSource
    }

    func openEditor(for project: BAS_SliderProject) {
        activeProject = project
        presentedSheet = .editor
    }
}

enum BAS_MainTab: Int, CaseIterable {
    case gallery
    case templates
    case create
    case favorites
    case settings

    var title: String {
        switch self {
        case .gallery: return "Gallery"
        case .templates: return "Templates"
        case .create: return "Create"
        case .favorites: return "Favorites"
        case .settings: return "Settings"
        }
    }

    var iconName: String {
        switch self {
        case .gallery: return "rectangle.stack.fill"
        case .templates: return "square.grid.2x2.fill"
        case .create: return "plus"
        case .favorites: return "star.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

enum BAS_SheetDestination: Identifiable {
    case createSource
    case editor
    case projectDetail(BAS_SliderProject)
    case generateRandom
    case stats
    case advancedDiscovery
    case profile

    var id: String {
        switch self {
        case .createSource: return "createSource"
        case .editor: return "editor"
        case .projectDetail(let p): return "detail_\(p.id.uuidString)"
        case .generateRandom: return "generateRandom"
        case .stats: return "stats"
        case .advancedDiscovery: return "advancedDiscovery"
        case .profile: return "profile"
        }
    }
}
