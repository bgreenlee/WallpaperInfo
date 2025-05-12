//
//  ImageView.swift
//  WallpaperInfo
//
//  Created by Brad Greenlee on 5/12/25.
//

import SwiftUI

struct ImageView: View {
    @StateObject var wallpaper = Wallpaper.shared

    var body: some View {
        if wallpaper.isLoading {
            ProgressView()
        } else {
            AsyncImage(url: URL(string: wallpaper.currentWallpaper?.previewImage ?? "")) { image in
                image
            } placeholder: {
                ProgressView()
            }
        }
    }
}

#Preview {
    ImageView()
}
