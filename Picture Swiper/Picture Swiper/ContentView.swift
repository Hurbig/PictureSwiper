//
//  ContentView.swift
//  Picture Swiper
//
//  Created by Carmen Marti on 23.03.2026.
//

import SwiftUI
import SwiftData
import Photos

struct ContentView: View {
    @StateObject var manager = PhotoManager()
    @State private var index = 0
    @State private var offset: CGSize = .zero

    var body: some View {
        VStack {
            if index < manager.assets.count {
                let asset = manager.assets[index]

                AssetImageView(asset: asset)
                    .offset(x: offset.width)
                    .rotationEffect(.degrees(offset.width / 20.0)) // optional but nice
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                            }
                            .onEnded { gesture in
                                handleSwipe(gesture: gesture, asset: asset)
                            }
                    )
                    .animation(.spring(), value: offset)

            } else {
                VStack {
                    Text("Done")
                    Button("Delete selected") {
                        manager.deleteMarked()
                    }
                }
            }
        }
        .onAppear {
            manager.requestPermission()
        }
    }

    func handleSwipe(gesture: DragGesture.Value, asset: PHAsset) {
        let threshold: CGFloat = 100

        if gesture.translation.width < -threshold {
            // LEFT = delete
            manager.toDelete.append(asset)
            animateSwipe(to: -1000)
        } else if gesture.translation.width > threshold {
            // RIGHT = keep
            animateSwipe(to: 1000)
        } else {
            offset = .zero
        }
    }
    
    func animateSwipe(to direction: CGFloat) {
        withAnimation(.easeIn(duration: 0.25)) {
            offset = CGSize(width: direction, height: 0)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            next()
        }
    }

    func next() {
        index += 1
        offset = .zero
    }
}
