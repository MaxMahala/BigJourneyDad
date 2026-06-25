import UIKit
import SwiftUI
import StoreKit

final class BAS_HapticManager {
    static let shared = BAS_HapticManager()
    
    private init() {}
    
    private var isEnabled: Bool {
        UserDefaults.standard.bool(forKey: "bas_haptics_enabled")
    }
    
    func triggerImpact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func triggerNotification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    func triggerSelection() {
        guard isEnabled else { return }
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}

final class BAS_ReviewManager {
    static let shared = BAS_ReviewManager()
    
    private init() {}
    
    func requestAppReview() {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
}
