import SwiftUI
import AVFoundation
import Photos
import UIKit
import Combine

enum BAS_PermissionState {
    case notDetermined
    case granted
    case denied
    case restricted
}

final class BAS_PermissionManager: ObservableObject {
    @Published var cameraState: BAS_PermissionState = .notDetermined
    @Published var galleryState: BAS_PermissionState = .notDetermined

    init() {
        refreshStates()
    }

    func refreshStates() {
        cameraState = mapCameraStatus(AVCaptureDevice.authorizationStatus(for: .video))
        galleryState = mapPhotoStatus(PHPhotoLibrary.authorizationStatus(for: .readWrite))
    }

    func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.cameraState = granted ? .granted : .denied
                completion(granted)
            }
        }
    }

    func requestGalleryAccess(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                self.galleryState = self.mapPhotoStatus(status)
                completion(status == .authorized || status == .limited)
            }
        }
    }

    func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    private func mapCameraStatus(_ status: AVAuthorizationStatus) -> BAS_PermissionState {
        switch status {
        case .authorized: return .granted
        case .denied: return .denied
        case .restricted: return .restricted
        case .notDetermined: return .notDetermined
        @unknown default: return .notDetermined
        }
    }

    private func mapPhotoStatus(_ status: PHAuthorizationStatus) -> BAS_PermissionState {
        switch status {
        case .authorized, .limited: return .granted
        case .denied: return .denied
        case .restricted: return .restricted
        case .notDetermined: return .notDetermined
        @unknown default: return .notDetermined
        }
    }
}
