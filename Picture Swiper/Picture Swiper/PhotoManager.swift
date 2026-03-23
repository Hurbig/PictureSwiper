//
//  PhotoManager.swift
//  Picture Swiper
//
//  Created by Carmen Marti on 23.03.2026.
//

import Foundation
import Photos
import Combine

class PhotoManager: ObservableObject {
    @Published var assets: [PHAsset] = []
    @Published var toDelete: [PHAsset] = []

    func requestPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                self.fetchPhotos()
            }
        }
    }

    func fetchPhotos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let result = PHAsset.fetchAssets(with: .image, options: options)

        var fetched: [PHAsset] = []
        result.enumerateObjects { asset, _, _ in
            fetched.append(asset)
        }

        DispatchQueue.main.async {
            self.assets = fetched
        }
    }

    func deleteMarked() {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets(self.toDelete as NSFastEnumeration)
        }
    }
}
