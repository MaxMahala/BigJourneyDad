import SwiftUI

@main
struct SlideStoryApp: App {
    @StateObject private var router = BAS_AppRouter()
    @StateObject private var projectStore = BAS_ProjectStore()
    @StateObject private var permissionManager = BAS_PermissionManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            BAS_RootContainerView()
                .environmentObject(router)
                .environmentObject(projectStore)
                .environmentObject(permissionManager)
                .preferredColorScheme(.dark)
        }
    }
}
