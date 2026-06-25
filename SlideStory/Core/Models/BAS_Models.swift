import SwiftUI
import Foundation

enum BAS_HandleShape: String, CaseIterable, Codable, Identifiable {
    case circleArrows
    case thinLine
    case diamond
    case dropShadowBar

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .circleArrows: return "Golden Orb"
        case .thinLine: return "Slim Line"
        case .diamond: return "Diamond"
        case .dropShadowBar: return "Bold Bar"
        }
    }
}

enum BAS_LabelStyle: String, CaseIterable, Codable, Identifiable {
    case pillTags
    case minimalText
    case ribbon
    case none

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .pillTags: return "Pill Tags"
        case .minimalText: return "Minimal"
        case .ribbon: return "Ribbon"
        case .none: return "Hidden"
        }
    }
}

enum BAS_SliderDirection: String, CaseIterable, Codable, Identifiable {
    case horizontal
    case vertical
    case diagonal

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .horizontal: return "Horizontal"
        case .vertical: return "Vertical"
        case .diagonal: return "Diagonal"
        }
    }

    var iconName: String {
        switch self {
        case .horizontal: return "arrow.left.and.right"
        case .vertical: return "arrow.up.and.down"
        case .diagonal: return "arrow.up.left.and.arrow.down.right"
        }
    }
}

struct BAS_ProjectStyleConfig: Codable, Equatable {
    var handleShape: BAS_HandleShape
    var labelStyle: BAS_LabelStyle
    var direction: BAS_SliderDirection
    var beforeText: String
    var afterText: String
    var showWatermark: Bool

    static let standard = BAS_ProjectStyleConfig(
        handleShape: .circleArrows,
        labelStyle: .pillTags,
        direction: .horizontal,
        beforeText: "BEFORE",
        afterText: "AFTER",
        showWatermark: true
    )
}

struct BAS_SliderProject: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var beforeImageName: String
    var afterImageName: String
    var createdAt: Date
    var category: BAS_ProjectCategory
    var style: BAS_ProjectStyleConfig
    var isFavorite: Bool
    var isMock: Bool

    init(
        id: UUID = UUID(),
        title: String,
        beforeImageName: String,
        afterImageName: String,
        createdAt: Date = Date(),
        category: BAS_ProjectCategory,
        style: BAS_ProjectStyleConfig = .standard,
        isFavorite: Bool = false,
        isMock: Bool = false
    ) {
        self.id = id
        self.title = title
        self.beforeImageName = beforeImageName
        self.afterImageName = afterImageName
        self.createdAt = createdAt
        self.category = category
        self.style = style
        self.isFavorite = isFavorite
        self.isMock = isMock
    }
}

enum BAS_ProjectCategory: String, CaseIterable, Codable, Identifiable {
    case portrait
    case fitness
    case interior
    case nature
    case renovation
    case art
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .portrait: return "Portrait"
        case .fitness: return "Fitness"
        case .interior: return "Interior"
        case .nature: return "Nature"
        case .renovation: return "Renovation"
        case .art: return "Art"
        case .other: return "Other"
        }
    }

    var iconName: String {
        switch self {
        case .portrait: return "person.crop.square"
        case .fitness: return "figure.strengthtraining.traditional"
        case .interior: return "house.fill"
        case .nature: return "leaf.fill"
        case .renovation: return "hammer.fill"
        case .art: return "paintpalette.fill"
        case .other: return "sparkles"
        }
    }
}

struct BAS_TemplatePreset: Identifiable {
    let id = UUID()
    let name: String
    let category: BAS_ProjectCategory
    let style: BAS_ProjectStyleConfig
}

struct BAS_OnboardPage: Identifiable {
    let id: Int
    let imageAssetName: String
    let titleText: String
    let subtitleText: String
}
