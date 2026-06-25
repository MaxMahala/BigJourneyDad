import SwiftUI
import Combine

final class BAS_ProjectStore: ObservableObject {
    @Published var projects: [BAS_SliderProject] = []

    private let storageKey = "bas_saved_projects_v1"

    init() {
        load()
        if projects.isEmpty {
            projects = BAS_MockDataFactory.makeMockProjects()
        }
    }

    func add(_ project: BAS_SliderProject) {
        projects.insert(project, at: 0)
        persist()
    }

    func remove(_ project: BAS_SliderProject) {
        projects.removeAll { $0.id == project.id }
        persist()
    }

    func toggleFavorite(_ project: BAS_SliderProject) {
        guard let idx = projects.firstIndex(where: { $0.id == project.id }) else { return }
        projects[idx].isFavorite.toggle()
        persist()
    }

    func update(_ project: BAS_SliderProject) {
        guard let idx = projects.firstIndex(where: { $0.id == project.id }) else { return }
        projects[idx] = project
        persist()
    }

    var favoriteProjects: [BAS_SliderProject] {
        projects.filter { $0.isFavorite }
    }

    func projects(in category: BAS_ProjectCategory) -> [BAS_SliderProject] {
        projects.filter { $0.category == category }
    }

    private func persist() {
        guard let encoded = try? JSONEncoder().encode(projects) else { return }
        UserDefaults.standard.set(encoded, forKey: storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        guard let decoded = try? JSONDecoder().decode([BAS_SliderProject].self, from: data) else { return }
        projects = decoded
    }
}

enum BAS_MockDataFactory {
    static func makeMockProjects() -> [BAS_SliderProject] {
        [
            BAS_SliderProject(
                title: "Golden Hour Glow",
                beforeImageName: "golden-hour-glow-stockcake",
                afterImageName: "golden-hour-glow-stockcake-filtered",
                createdAt: Date().addingTimeInterval(-3600 * 26),
                category: .portrait,
                style: .standard,
                isFavorite: true,
                isMock: true
            ),
            BAS_SliderProject(
                title: "Sunset Horizon",
                beforeImageName: "premium_photo-1673623135721-a0ea3caff642",
                afterImageName: "premium_photo-1673623135721-a0ea3caff642-filtered",
                createdAt: Date().addingTimeInterval(-3600 * 50),
                category: .nature,
                style: BAS_ProjectStyleConfig(handleShape: .diamond, labelStyle: .ribbon, direction: .horizontal, beforeText: "BEFORE", afterText: "AFTER", showWatermark: true),
                isFavorite: false,
                isMock: true
            ),
            BAS_SliderProject(
                title: "Living Room Makeover",
                beforeImageName: "roomBad",
                afterImageName: "roomExcellent",
                createdAt: Date().addingTimeInterval(-3600 * 90),
                category: .renovation,
                style: BAS_ProjectStyleConfig(handleShape: .dropShadowBar, labelStyle: .minimalText, direction: .vertical, beforeText: "OLD", afterText: "NEW", showWatermark: true),
                isFavorite: true,
                isMock: true
            ),
            BAS_SliderProject(
                title: "12 Week Transformation",
                beforeImageName: "badBody",
                afterImageName: "excellentBody",
                createdAt: Date().addingTimeInterval(-3600 * 140),
                category: .fitness,
                style: BAS_ProjectStyleConfig(handleShape: .circleArrows, labelStyle: .pillTags, direction: .horizontal, beforeText: "DAY 1", afterText: "DAY 84", showWatermark: true),
                isFavorite: false,
                isMock: true
            )
        ]
    }

    static func makeTemplatePresets() -> [BAS_TemplatePreset] {
        [
            BAS_TemplatePreset(name: "Glow Up", category: .portrait, style: BAS_ProjectStyleConfig(handleShape: .circleArrows, labelStyle: .pillTags, direction: .horizontal, beforeText: "BEFORE", afterText: "AFTER", showWatermark: true)),
            BAS_TemplatePreset(name: "Studio Light", category: .portrait, style: BAS_ProjectStyleConfig(handleShape: .thinLine, labelStyle: .minimalText, direction: .horizontal, beforeText: "RAW", afterText: "EDITED", showWatermark: true)),
            BAS_TemplatePreset(name: "Transformation", category: .fitness, style: BAS_ProjectStyleConfig(handleShape: .dropShadowBar, labelStyle: .ribbon, direction: .vertical, beforeText: "START", afterText: "NOW", showWatermark: true)),
            BAS_TemplatePreset(name: "Macro Gains", category: .fitness, style: BAS_ProjectStyleConfig(handleShape: .diamond, labelStyle: .pillTags, direction: .horizontal, beforeText: "WEEK 1", afterText: "WEEK 12", showWatermark: true)),
            BAS_TemplatePreset(name: "Home Reveal", category: .interior, style: BAS_ProjectStyleConfig(handleShape: .circleArrows, labelStyle: .ribbon, direction: .horizontal, beforeText: "BEFORE", afterText: "AFTER", showWatermark: true)),
            BAS_TemplatePreset(name: "Golden Hour", category: .nature, style: BAS_ProjectStyleConfig(handleShape: .thinLine, labelStyle: .minimalText, direction: .diagonal, beforeText: "DAWN", afterText: "DUSK", showWatermark: true)),
            BAS_TemplatePreset(name: "Restoration", category: .renovation, style: BAS_ProjectStyleConfig(handleShape: .dropShadowBar, labelStyle: .pillTags, direction: .vertical, beforeText: "OLD", afterText: "NEW", showWatermark: true)),
            BAS_TemplatePreset(name: "Gallery Frame", category: .art, style: BAS_ProjectStyleConfig(handleShape: .diamond, labelStyle: .ribbon, direction: .horizontal, beforeText: "SKETCH", afterText: "FINAL", showWatermark: true))
        ]
    }
}
