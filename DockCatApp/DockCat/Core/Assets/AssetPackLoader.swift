import AppKit
import Foundation

enum AssetPackLoaderError: Error, Equatable {
    case missingManifest
    case missingRestingPose
    case missingWalkFrame
    case missingRequiredFile(String)
}

final class AssetPackLoader {
    private let fileManager: FileManager
    private let bundle: Bundle

    init(fileManager: FileManager = .default, bundle: Bundle = .main) {
        self.fileManager = fileManager
        self.bundle = bundle
    }

    func loadSelectedPack(selectedID: String) -> CatAssetPack {
        if let custom = customPacks(allowIncomplete: true).first(where: { $0.id == selectedID }) {
            return custom
        }
        return loadDefaultPack()
    }

    func loadDefaultPack() -> CatAssetPack {
        let candidates = [
            bundle.resourceURL?.appendingPathComponent("DefaultCat"),
            bundle.resourceURL?.appendingPathComponent("Resources/DefaultCat"),
            URL(fileURLWithPath: #filePath)
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent("Resources/DefaultCat")
        ].compactMap { $0 }

        for url in candidates {
            if let pack = try? loadPack(at: url) {
                return pack
            }
        }

        let fallbackManifest = AssetManifest(
            id: "default-lizz",
            name: "Lizz",
            author: "Auwuua",
            canvasWidth: 1254,
            canvasHeight: 1254,
            defaultAnchor: .init(x: 0.5, y: 0.88),
            poses: .init(resting: "poses/resting", held: "poses/held", dialogue: "poses/dialogue", transition: "poses/transition"),
            animations: .init(
                walk: .init(fps: 3, frames: [])
            )
        )
        return CatAssetPack(manifest: fallbackManifest, rootURL: candidates.first ?? URL(fileURLWithPath: "/"))
    }

    func customPacks(allowIncomplete: Bool = true) -> [CatAssetPack] {
        let root = customPacksRoot()
        guard let children = try? fileManager.contentsOfDirectory(at: root, includingPropertiesForKeys: [.isDirectoryKey]) else {
            return []
        }
        return children.compactMap { try? loadPack(at: $0, allowIncomplete: allowIncomplete) }
    }

    func customPacksRoot() -> URL {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Library/Application Support")
        return appSupport.appendingPathComponent("DockCat/CatPacks", isDirectory: true)
    }

    func loadPack(at rootURL: URL, allowIncomplete: Bool = false) throws -> CatAssetPack {
        let manifestURL = rootURL.appendingPathComponent("manifest.json")
        guard fileManager.fileExists(atPath: manifestURL.path) else {
            throw AssetPackLoaderError.missingManifest
        }
        let data = try Data(contentsOf: manifestURL)
        let manifest = try JSONDecoder().decode(AssetManifest.self, from: data)
        let pack = CatAssetPack(manifest: manifest, rootURL: rootURL)
        guard !allowIncomplete else {
            return pack
        }
        guard !loadablePoseURLs(in: pack.restingPosesDirectoryURL).isEmpty else {
            throw AssetPackLoaderError.missingRestingPose
        }
        guard !loadableWalkFrameURLs(in: pack).isEmpty else {
            throw AssetPackLoaderError.missingWalkFrame
        }
        for (path, directoryURL) in requiredPoseDirectories(in: pack) {
            guard !loadablePoseURLs(in: directoryURL).isEmpty else {
                throw AssetPackLoaderError.missingRequiredFile(path)
            }
        }
        return pack
    }

    private func requiredPoseDirectories(in pack: CatAssetPack) -> [(String, URL)] {
        [
            (pack.manifest.poses.held, pack.heldPosesDirectoryURL),
            (pack.manifest.poses.dialogue, pack.dialoguePosesDirectoryURL),
            (pack.manifest.poses.transition, pack.transitionPosesDirectoryURL)
        ]
    }

    private func loadablePoseURLs(in directoryURL: URL) -> [URL] {
        guard let urls = try? fileManager.contentsOfDirectory(
            at: directoryURL,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else {
            return []
        }

        return urls
            .filter { url in
                let values = try? url.resourceValues(forKeys: [.isRegularFileKey])
                return values?.isRegularFile == true && NSImage(contentsOf: url) != nil
            }
            .sorted { $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending }
    }

    private func loadableWalkFrameURLs(in pack: CatAssetPack) -> [URL] {
        guard let urls = try? fileManager.contentsOfDirectory(
            at: pack.walkAnimationDirectoryURL,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else {
            return []
        }

        return urls
            .filter { url in
                let values = try? url.resourceValues(forKeys: [.isRegularFileKey])
                return values?.isRegularFile == true && NSImage(contentsOf: url) != nil
            }
            .sorted { $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending }
    }
}
