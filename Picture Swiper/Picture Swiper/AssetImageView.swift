//
//  AssetImageView.swift
//  Picture Swiper
//
//  Created by Carmen Marti on 23.03.2026.
//

import SwiftUI
import Photos

struct AssetImageView: View {
    let asset: PHAsset
    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loadImage()
        }
    }

    func loadImage() {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = false

        manager.requestImage(for: asset,
                             targetSize: CGSize(width: 1000, height: 1000),
                             contentMode: .aspectFit,
                             options: options) { img, _ in
            self.image = img
        }
    }
}
