//
//  Wallpaper.swift
//  WallpaperInfo
//
//  Created by Brad Greenlee on 11/4/24.
//

import Foundation
import SwiftUI

struct WallpaperAsset: Decodable, CustomStringConvertible {
    let id: String
    let showInTopLevel: Bool
    let shotID: String
    let localizedNameKey: String
    let accessibilityLabel: String
    let pointsOfInterest: [String: String]
    let previewImage: String
    let includeInShuffle: Bool
    let url4KSDR240FPS: String
    let subcategories: [String]
    let preferredOrder: Int
    let categories: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case showInTopLevel
        case shotID
        case localizedNameKey
        case accessibilityLabel
        case pointsOfInterest
        case previewImage
        case includeInShuffle
        case url4KSDR240FPS = "url-4K-SDR-240FPS"
        case subcategories
        case preferredOrder
        case categories
    }

    var description: String {
        if let bundle = Bundle(path: "/Library/Application Support/com.apple.idleassetsd/Customer/TVIdleScreenStrings.bundle") {
            return bundle.localizedString(forKey: localizedNameKey, value: nil, table: "Localizable.nocache")
        } else {
            return "unknown"
        }
    }
}

struct WallpaperAssets: Decodable {
    let version: Int
    let localizationVersion: String
    let assets: [WallpaperAsset]
}

class Wallpaper: ObservableObject {
    var assets: [WallpaperAsset] = [] // TODO: make this a dict

    @Published var currentWallpaper: WallpaperAsset? = nil

    static let shared = Wallpaper()

    init() {
        let json = try! String(contentsOfFile: "/Library/Application Support/com.apple.idleassetsd/Customer/entries.json", encoding: .utf8)
        let decoder = JSONDecoder()
        do {
            let res = try decoder.decode(WallpaperAssets.self, from: json.data(using: .utf8)!)
            self.assets = res.assets
        } catch {
            print(error)
        }
    }

    func getAsset(id: String) -> WallpaperAsset? {
        assets.first(where: { $0.id == id })
    }

    func getCurrentWallpaper() -> WallpaperAsset? {
        // get the PID of the process that updates the aerial wallpapers
        let pid = shell("/usr/bin/pgrep", "WallpaperVideoExtension").trimmingCharacters(in: .whitespacesAndNewlines)
        // look for a .mov file in the files that process has open
        let openFiles = shell("/usr/sbin/lsof", "-Fn", "-p", pid)
        // find the first file ending in .mov and extract the ID from it
        if let wallpaperFile = openFiles.split(whereSeparator: \.isNewline)
            .first(where: { $0.hasSuffix(".mov") }) {
            let id = URL(fileURLWithPath: String(wallpaperFile))
                .lastPathComponent
                .split(separator: ".")
                .first!
            // look up the wallpaper asset by ID
            return Wallpaper.shared.getAsset(id: String(id))
        }
        return nil
    }

    func updateCurrentWallpaper() {
        currentWallpaper = getCurrentWallpaper()
    }
}
