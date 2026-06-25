import SwiftUI
import UIKit
import Combine

enum BAS_PhotoSlot {
    case before
    case after
}

enum BAS_ActiveCaptureSheet: Identifiable {
    case camera(BAS_PhotoSlot)
    case gallery(BAS_PhotoSlot)

    var id: String {
        switch self {
        case .camera(let slot): return "camera_\(slot)"
        case .gallery(let slot): return "gallery_\(slot)"
        }
    }
}

final class BAS_CreateProjectViewModel: ObservableObject {
    @Published var beforeImage: UIImage?
    @Published var afterImage: UIImage?
    @Published var activeSheet: BAS_ActiveCaptureSheet?
    @Published var showPermissionAlert: Bool = false
    @Published var permissionAlertMessage: String = ""
    @Published var selectedCategory: BAS_ProjectCategory = .other
    @Published var projectTitle: String = ""
    @Published var styleConfig: BAS_ProjectStyleConfig = .standard

    var bothImagesReady: Bool {
        beforeImage != nil && afterImage != nil
    }

    func requestSource(for slot: BAS_PhotoSlot, useCamera: Bool, permissionManager: BAS_PermissionManager) {
        if useCamera {
            handleCameraRequest(slot: slot, permissionManager: permissionManager)
        } else {
            handleGalleryRequest(slot: slot, permissionManager: permissionManager)
        }
    }

    private func handleCameraRequest(slot: BAS_PhotoSlot, permissionManager: BAS_PermissionManager) {
        switch permissionManager.cameraState {
        case .granted:
            activeSheet = .camera(slot)
        case .notDetermined:
            permissionManager.requestCameraAccess { [weak self] granted in
                if granted {
                    self?.activeSheet = .camera(slot)
                } else {
                    self?.presentPermissionDenied(forCamera: true)
                }
            }
        case .denied, .restricted:
            presentPermissionDenied(forCamera: true)
        }
    }

    private func handleGalleryRequest(slot: BAS_PhotoSlot, permissionManager: BAS_PermissionManager) {
        switch permissionManager.galleryState {
        case .granted:
            activeSheet = .gallery(slot)
        case .notDetermined:
            permissionManager.requestGalleryAccess { [weak self] granted in
                if granted {
                    self?.activeSheet = .gallery(slot)
                } else {
                    self?.presentPermissionDenied(forCamera: false)
                }
            }
        case .denied, .restricted:
            presentPermissionDenied(forCamera: false)
        }
    }

    private func presentPermissionDenied(forCamera: Bool) {
        permissionAlertMessage = forCamera
            ? "Camera access is currently disabled. Enable it in Settings to capture new photos."
            : "Photo Library access is currently disabled. Enable it in Settings to import your images."
        showPermissionAlert = true
    }

    func assignPicked(image: UIImage, slot: BAS_PhotoSlot) {
        switch slot {
        case .before: beforeImage = image
        case .after: afterImage = image
        }
        activeSheet = nil
    }

    func buildProject() -> BAS_SliderProject? {
        guard let before = beforeImage, let after = afterImage else { return nil }
        let beforeId = BAS_ImageStorage.shared.saveImage(before)
        let afterId = BAS_ImageStorage.shared.saveImage(after)
        let finalTitle = projectTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "Untitled Slider"
            : projectTitle
        return BAS_SliderProject(
            title: finalTitle,
            beforeImageName: beforeId,
            afterImageName: afterId,
            category: selectedCategory,
            style: styleConfig,
            isMock: false
        )
    }

    func reset() {
        beforeImage = nil
        afterImage = nil
        projectTitle = ""
        selectedCategory = .other
        styleConfig = .standard
    }
}
