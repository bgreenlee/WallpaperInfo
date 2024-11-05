//
//  WallpaperInfoApp.swift
//  WallpaperInfo
//
//  Created by Brad Greenlee on 11/4/24.
//

import SwiftUI

@main
struct WallpaperInfoApp: App {
    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .onAppear {
                    Wallpaper.shared.updateCurrentWallpaper()
                }
        } label: {
            Image(systemName: "info.bubble")
        }
        .menuBarExtraStyle(.window)
    }
}
