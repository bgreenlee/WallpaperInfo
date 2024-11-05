//
//  ContentView.swift
//  WallpaperInfo
//
//  Created by Brad Greenlee on 11/4/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var wallpaper = Wallpaper.shared

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: wallpaper.currentWallpaper?.previewImage ?? "")) { image in
                image
            } placeholder: {
                ProgressView()
            }
            .frame(width: 214, height: 130)
            Text(wallpaper.currentWallpaper?.description ?? "No aerial wallpaper set")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
