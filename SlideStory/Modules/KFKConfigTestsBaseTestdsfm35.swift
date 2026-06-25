import SwiftUI
import StoreKit

public struct FMremote__objectskdg34: Codable, Hashable, Identifiable {
    public let id: String
    public let icon: String
    public let name: String
    public let secondsPerStep: Int
    public let steps: [String]
}

public struct KDKKKInitFComposedmsm_Fmm4335: Codable, Hashable, Identifiable {
    public let id: String?
    public let title: String?
    public let synopsis: String?
    public let symbol: String?
    public let readMinutes: Int?
    public let tags: [String]?
    public let bodyMarkdown: String?
}

public struct FMKObjectInstrumentor_TransferMock: Codable, Hashable {
    public let dailyGoal: Int
    public let season: String?
    public let privacyUrl: String?
}

public struct KFKObejct_FKGKMockModeManager: Codable, Hashable {
    public let rituals: [FMremote__objectskdg34]?
    public let tales: [KDKKKInitFComposedmsm_Fmm4335]?
    public let config: FMKObjectInstrumentor_TransferMock?
}

public final class KFKConfigTestsBaseTestdsfm35 {
    public static let dsfkgkinit = KFKConfigTestsBaseTestdsfm35()

    private let remoteEndpointURL = URL(string: "https://bigdaddyadv.com/appconfig")!

    private let userDefaultsStorage = UserDefaults.standard
    private let userDefaultsPayloadKey = "SlidedStory.remoteContentEnvelope.payload.v2"

    private let jsonDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .useDefaultKeys
        return d
    }()

    private let jsonEncoder: JSONEncoder = {
        let e = JSONEncoder()
        e.outputFormatting = [.withoutEscapingSlashes]
        return e
    }()

    private init() {}

    @discardableResult
    public func fetchDecodeAndPersiJjjxjstRemoteContemxntEnvelope()
    async throws -> KFKObejct_FKGKMockModeManager {
        var request = URLRequest(url: remoteEndpointURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        if let raw = String(data: data, encoding: .utf8) {
        }

        let envelope = try decodeEnvelopeOrConfig(from: data)
        try persistDecodedEnvelopeToUserDefaults(envelope)
        return envelope
    }

    private func decodeEnvelopeOrConfig(from data: Data) throws -> KFKObejct_FKGKMockModeManager {
        if let env = try? jsonDecoder.decode(KFKObejct_FKGKMockModeManager.self, from: data),
           env.config != nil {
            return env
        }
        let cfg = try jsonDecoder.decode(FMKObjectInstrumentor_TransferMock.self, from: data)
        return KFKObejct_FKGKMockModeManager(rituals: nil, tales: nil, config: cfg)
    }

    public func loadPeevreventEnvelopeFromUserDefaults()
    -> KFKObejct_FKGKMockModeManager? {
        guard let data = userDefaultsStorage.data(forKey: userDefaultsPayloadKey) else { return nil }
        return try? jsonDecoder.decode(KFKObejct_FKGKMockModeManager.self, from: data)
    }

    public func loadCachedSeason() -> String? {
        guard let env = loadPeevreventEnvelopeFromUserDefaults() else { return nil }
        return env.config?.season
    }

    public func clearPersistedRemoteContentEnvelopeFromUserDefaults() {
        userDefaultsStorage.removeObject(forKey: userDefaultsPayloadKey)
    }

    private func persistDecodedEnvelopeToUserDefaults(_ envelope: KFKObejct_FKGKMockModeManager) throws {
        let data = try jsonEncoder.encode(envelope)
        userDefaultsStorage.set(data, forKey: userDefaultsPayloadKey)
    }
}
