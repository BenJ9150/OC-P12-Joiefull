//
//  FullScreenPictureView.swift
//  Joiefull
//
//  Created by Benjamin LEFRANCOIS on 28/02/2025.
//

import SwiftUI

struct FullScreenPictureView: View {

    // MARK: Public properties

    @Binding var isPresented: Bool
    let image: Image

    // MARK: Private properties

    /// Zoom
    @State private var relativeZoom: CGFloat = 0
    @State private var lastZoom: CGFloat = 1
    @State private var scale: CGFloat = 1

    /// Offset
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var imageRatio: CGFloat = 1

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
                .background(GeometryReader { geo in
                    Color.clear
                        .onAppear { imageRatio = geo.size.width / geo.size.height }
                })
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
        if relativeZoom < 0 {
            /// Zoom out
            reinitOffset(animDuration: 1)
        }
        updateScale()
    }

    func handleOnEndedZoom() {
        /// If lastZoom == 1, image was not zoom before this gesture
        /// Check if this gesture is a zoom out and close view if relativeZoom is significant
        if lastZoom == 1 && relativeZoom < -0.6 {
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
            width: newOffset(translation.width + lastOffset.width, axis: .horizontal),
            height: newOffset(translation.height + lastOffset.height, axis: .vertical)
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
            reinitOffset()
        }
    }

    func reinitOffset(animDuration: TimeInterval = 0.3) {
        lastOffset = .zero
        withAnimation(.interactiveSpring(duration: animDuration)) {
            offset = .zero
        }
    }

    func newOffset(_ value: CGFloat, axis: Axis.Set) -> CGFloat {
        guard scale > 1 else { return 0 }

        let screenSize = UIScreen.main.bounds.size
        let imageSize =  CGSize(width: screenSize.width * scale, height: screenSize.width / imageRatio * scale)

        let maxOffset: CGFloat
        if axis == .horizontal {
            maxOffset = max((imageSize.width - screenSize.width) / 2, 0)
        } else {
            maxOffset = max((imageSize.height - screenSize.height) / 2, 0)
        }

        return min(max(value, -maxOffset), maxOffset)
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
