//
//  FullScreenPictureView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 28/02/2025.
//

import SwiftUI

struct FullScreenPictureView: View {

    @State private var relativeZoom: CGFloat = 0
    @State private var lastZoom: CGFloat = 1
    @State private var scale: CGFloat = 1
    @State var offset: CGSize = .zero
    @State var lastOffset: CGSize = .zero
    @Binding var isPresented: Bool

    let image: Image

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).edgesIgnoringSafeArea(.all)
            image
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    MagnifyGesture()
                        .onChanged { value in
                            handleOnChangedZoom(value.magnification)
                        }
                        .onEnded { _ in
                            handleOnEndedZoom()
                        }
                        .simultaneously(
                            with: DragGesture(minimumDistance: 0)
                                .onChanged({ value in
                                    handleOnChangedOffset(value.translation)
                                })
                                .onEnded({ _ in
                                    handleOnEndedOffset()
                                })
                        )
                )
                .onAppear {
                    print(image)
                }
        }
        .overlay(alignment: .bottom) {
            Button("Fermer") {
                isPresented.toggle()
            }
            .buttonStyle(JoifullButton())
            .padding(.bottom, 16)
        }
    }
}

// MARK: Zoom

private extension FullScreenPictureView {

    func handleOnChangedZoom(_ magnification: CGFloat) {
        /// magnification value start to 1, so remove 1 to have relative zoom
        if lastZoom == 1 {
            /// First zoom
            relativeZoom = magnification - 1
        } else {
            relativeZoom = (magnification - 1) * abs(lastZoom)
        }
        updateScale()
    }

    func handleOnEndedZoom() {
        /// If lastZoom == 1, image was not zoom before this gesture
        /// Check if this gesture is a zoom out and close view if relativeZoom is significant
        if lastZoom == 1 && relativeZoom < -0.5 {
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                isPresented.toggle()
            }
        }
        lastZoom = min(max(lastZoom + relativeZoom, 1), 6)
        relativeZoom = 0
        updateScale()
    }

    func updateScale() {
        withAnimation(.interactiveSpring) {
            scale = relativeZoom + lastZoom
            reinitOffsetIfNeeded()
        }
    }
}

// MARK: Offset

private extension FullScreenPictureView {

    func handleOnChangedOffset(_ translation: CGSize) {
        let newOffset = CGSize(
            width: clampOffset(translation.width + lastOffset.width, axis: .horizontal),
            height: clampOffset(translation.height + lastOffset.height, axis: .vertical)
        )

        withAnimation(.interactiveSpring) {
            offset = newOffset
        }
    }

    func handleOnEndedOffset() {
        lastOffset = offset
        reinitOffsetIfNeeded()
    }

    func reinitOffsetIfNeeded() {
        if scale == 1 {
            lastOffset = .zero
            withAnimation(.interactiveSpring) {
                offset = .zero
            }
        }
    }

    func clampOffset(_ value: CGFloat, axis: Axis.Set) -> CGFloat {
        guard scale > 1 else { return 0 }

        let screenSize = UIScreen.main.bounds.size
        let imageSize = imageSizeInView()

        let maxOffset: CGFloat
        if axis == .horizontal {
            maxOffset = max((imageSize.width - screenSize.width) / 2, 0)
        } else {
            maxOffset = max((imageSize.height - screenSize.height) / 2, 0)
        }

        return min(max(value, -maxOffset), maxOffset)
    }

    func imageSizeInView() -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        let imageAspectRatio = imageSizeRatio()

        let displayWidth = screenSize.width * scale
        let displayHeight = screenSize.width / imageAspectRatio * scale

        return CGSize(width: displayWidth, height: displayHeight)
    }

    func imageSizeRatio() -> CGFloat {
        let screenSize = UIScreen.main.bounds.size
        return screenSize.width / screenSize.height
    }
}

// MARK: - Preview

#Preview("Fullscreen") {
    @Previewable @State var isPresented = true
    FullScreenPictureView(isPresented: $isPresented, image: ClothesPreview().clothingImage())
}

#Preview("From PictureView") {
    PictureView(for: ClothesPreview().getClothing(), height: 300, isDetailView: true)
        .padding(.all, 32)
}
