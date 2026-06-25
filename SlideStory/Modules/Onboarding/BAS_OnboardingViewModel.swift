import SwiftUI
import Combine

final class BAS_OnboardingViewModel: ObservableObject {
    @Published var currentIndex: Int = 0

    let pages: [BAS_OnboardPage] = [
        BAS_OnboardPage(
            id: 0,
            imageAssetName: "Gemini_Generated_Image_d948rhd948rhd948",
            titleText: "Craft Stunning Before / After Stories",
            subtitleText: "Drag a gleaming gold divider across any two photos and reveal your transformation in style."
        ),
        BAS_OnboardPage(
            id: 1,
            imageAssetName: "Gemini_Generated_Image_d948rhd948rhd948 (1)",
            titleText: "Capture or Import in Seconds",
            subtitleText: "Snap a fresh photo with your camera or pull existing shots straight from your gallery."
        ),
        BAS_OnboardPage(
            id: 2,
            imageAssetName: "Gemini_Generated_Image_d948rhd948rhd948 (2)",
            titleText: "Premium Templates, Ready to Use",
            subtitleText: "Choose from curated violet and gold presets for fitness, beauty, home and more."
        ),
        BAS_OnboardPage(
            id: 3,
            imageAssetName: "Gemini_Generated_Image_d948rhd948rhd948 (3)",
            titleText: "Export and Share Effortlessly",
            subtitleText: "Save your slider creation to your library or share it instantly with the world."
        )
    ]

    var isLastPage: Bool {
        currentIndex == pages.count - 1
    }

    func advance(completion: () -> Void) {
        if isLastPage {
            completion()
        } else {
            withAnimation(.easeInOut(duration: 0.35)) {
                currentIndex += 1
            }
        }
    }

    func skipToEnd() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentIndex = pages.count - 1
        }
    }
}
