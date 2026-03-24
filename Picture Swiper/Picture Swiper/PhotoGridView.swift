//
//  PhotoGridView.swift
//  Picture Swiper
//
//  Created by Carmen Marti on 23.03.2026.
//
import SwiftUI
import SwiftData
import Photos

struct PhotoGridView: View {
    @ObservedObject var manager: PhotoManager
    @Binding var startIndex: Int

    let columns = Array(repeating: GridItem(.flexible()), count: 4)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(Array(manager.assets.enumerated()), id: \.1.localIdentifier) { i, asset in
                    AssetImageView(asset: asset)
                        .frame(width: 80, height: 80)
                        .clipped()
                        .onTapGesture {
                            startIndex = i
                        }
                }
            }
        }
    }
}
