import Foundation

final class PushTKKFo435TokenMger {
    static let sdgk4k35sharedInit = PushTKKFo435TokenMger()

    private let tokenKFk_fkk435Key = "firebase_fcm_token"
    private let lastJFKk4354TokenKey = "last_sent_fcm_token"

    private init() {}

    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKFk_fkk435Key)

        print("🔥 PushTokenManager: token saved")
        print("🔥 PushTokenManager token: \(token)")

        if let envelope = KFKConfigTestsBaseTestdsfm35.dsfkgkinit.loadPeevreventEnvelopeFromUserDefaults(),
           let privacyUrl = envelope.config?.privacyUrl,
           privacyUrl != "https://example.com/privacy" {

            trySendTokenIfPossible()
        }
    }

    func trySendTokenIfPossible() {

        guard let token = UserDefaults.standard.string(forKey: tokenKFk_fkk435Key) else {
            print("❌ PushTokenManager: FCM token not found")
            return
        }

        guard let envelope = KFKConfigTestsBaseTestdsfm35.dsfkgkinit.loadPeevreventEnvelopeFromUserDefaults() else {
            print("❌ PushTokenManager: remote config not loaded")
            return
        }

        guard let privacyUrl = envelope.config?.privacyUrl,
              !privacyUrl.isEmpty else {
            print("❌ PushTokenManager: privacyUrl missing")
            return
        }

        let trimmedUrl = privacyUrl.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedUrl == "https://example.com/privacy" {
            print("ℹ️ PushTokenManager: placeholder privacyUrl detected")
            return
        }

        if UserDefaults.standard.string(forKey: lastJFKk4354TokenKey) == token {
            print("ℹ️ PushTokenManager: token already synced")
            return
        }

        print("📨 PushTokenManager privacyUrl:")
        print(privacyUrl)

        guard let url = URL(string: privacyUrl) else {
            print("❌ PushTokenManager: invalid privacyUrl")
            return
        }

        let body: [String: Any] = [
            "token": token,
            "provider": "firebase"
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("❌ PushTokenManager: failed to serialize json")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        print("📨 Request URL:")
        print(url.absoluteString)

        if let bodyString = String(data: jsonData, encoding: .utf8) {
            print("📨 Request body:")
            print(bodyString)
        }

        print("🚀 PushTokenManager: sending token...")
        print("🚀 Token: \(token)")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error {
                print("❌ PushTokenManager error:")
                print(error.localizedDescription)
                return
            }

            guard let http = response as? HTTPURLResponse else {
                print("❌ PushTokenManager: no HTTP response")
                return
            }

            print("📡 PushTokenManager status code: \(http.statusCode)")

            if let data,
               let responseText = String(data: data, encoding: .utf8),
               !responseText.isEmpty {

                print("📄 PushTokenManager response:")
                print(responseText)
            }

            if (200...299).contains(http.statusCode) {

                UserDefaults.standard.set(token, forKey: self.lastJFKk4354TokenKey)

                print("✅ PushTokenManager SUCCESS")
                print("✅ PushTokenManager token synced")

            } else {

                print("⚠️ PushTokenManager FAILED")
            }

        }.resume()
    }
}
