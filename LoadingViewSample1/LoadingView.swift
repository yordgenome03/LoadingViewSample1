//
//  LoadingView.swift
//  LoadingViewSample1
//
//  Created by YomEngine on 2023/12/28.
//

import SwiftUI
import Combine

struct LoadingView<T: Shape>: View {
    let objectShape: T
    let frameSize: CGFloat
    var radius: CGFloat { frameSize / 5 }
    var size: CGFloat { radius * 2 }
    let animationDuration: Double
    let numberOfPoints: Int
    let colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    var pointSize: CGFloat { radius * 0.2 }
    let pointScaleRatio: CGFloat
    @State private var rotateAngle: Double = 0
    @State private var pointScale: CGFloat = 1.0
    @State private var timer: AnyCancellable?
    @State private var cancellables: [AnyCancellable] = []
    let addOppositeAnimation: Bool
    let shadowRadius: CGFloat
    let shadowOffset: CGFloat
    let shadowOpacity: CGFloat
    var backgroundCornerRadius: CGFloat { frameSize / 10 }
    let backgroundOpacity: CGFloat
    let addBackground: Bool
    
    init(objectShape: T = Circle(),
         frameSize: CGFloat = 300,
         animationDuration: Double = 2.0,
         numberOfPoints: Int = 5,
         pointScaleRatio: CGFloat = 1.0,
         addOppositeAnimation: Bool = true,
         shadowRadius: CGFloat = 20,
         shadowOffset: CGFloat = 20,
         shadowOpacity: CGFloat = 0.5,
         backgroundOpacity: CGFloat = 0.3,
         addBackground: Bool = true
    ) {
        self.objectShape = objectShape
        self.frameSize = frameSize
        self.animationDuration = animationDuration
        self.numberOfPoints = numberOfPoints
        self.pointScaleRatio = pointScaleRatio
        self.addOppositeAnimation = addOppositeAnimation
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.shadowOpacity = shadowOpacity
        self.backgroundOpacity = backgroundOpacity
        self.addBackground = addBackground
    }
    
    var body: some View {
        ZStack {
            if addBackground {
                RoundedRectangle(cornerRadius: backgroundCornerRadius)
                    .background(.ultraThinMaterial)
                    .opacity(backgroundOpacity)
            }
            
            ZStack {
                ForEach(0..<numberOfPoints, id: \.self) { index in
                    MovingPoint(index: index, isOpposite: false)
                        .rotationEffect(.degrees(rotateAngle))
                        .position(positionOfOrbitPath(index: index))
                        .rotationEffect(.degrees(-90))
                        .shadow(color: colors[index % colors.count].opacity(0.5),
                                radius: shadowRadius(shadowRadius, isOpposite: false),
                                y: shadowOffset(shadowOffset, isOpposite: false))
                }
                .offset(y: -shadowOffset(shadowOffset, isOpposite: false))
                
                if addOppositeAnimation {
                    ForEach(0..<numberOfPoints, id: \.self) { index in
                        MovingPoint(index: index, isOpposite: true)
                            .rotationEffect(.degrees(-rotateAngle + 180))
                            .position(positionOfOrbitPath(index: index))
                            .rotationEffect(.degrees(-90))
                            .shadow(color: colors[index % colors.count].opacity(0.5),
                                    radius: shadowRadius(shadowRadius, isOpposite: true),
                                    y: shadowOffset(shadowOffset, isOpposite: true))
                    }
                    .rotationEffect(.degrees(180))
                    .offset(y: shadowOffset(shadowOffset, isOpposite: true))
                }
            }
            .frame(width: size, height: size)
            .onAppear {
                let animationSteps: CGFloat = 36
                Timer.publish(every: animationDuration / animationSteps, on: .main, in: .default)
                    .autoconnect()
                    .eraseToAnyPublisher()
                    .sink { _ in
                        withAnimation(.linear) {
                            rotateAngle += (360.0 / animationSteps)
                            
                            let baseScale = 1.0
                            let scaleOffset = rotateAngle < 180
                            ? CGFloat(rotateAngle) / 180
                            : CGFloat(360 - rotateAngle) / 180
                            pointScale = pointScaleRatio * (baseScale + scaleOffset)
                        }
                        
                        if rotateAngle >= 360 {
                            rotateAngle = 0
                        }
                    }
                    .store(in: &cancellables)
            }
        }
        .frame(width: frameSize, height: frameSize)
    }
    
    @ViewBuilder
    private func MovingPoint(index: Int, isOpposite: Bool) -> some View {
        ZStack {
            objectShape
                .fill(colors[index % colors.count])
                .frame(width: pointSize, height: pointSize)
                .scaleEffect(pointScale)
                .offset(offsetOfMovingPoint(index: index))
                .animation(.linear.delay(isOpposite ?  animationDuration/2 : 0), value: pointScale)
        }
    }
    
    private func shadowRadius(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let scale = pointScale / pointScaleRatio
        let shadowRadiusRatio = isOpposite
        ? 1.0 - (scale - 1.0)
        : scale - 1.0
        return value * shadowRadiusRatio
    }
    
    private func shadowOffset(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let scale = pointScale / pointScaleRatio
        let shadowOffsetRatio = isOpposite
        ? -(1.0 - (scale - 1.0))
        : scale - 1.0
        return value * shadowOffsetRatio
    }
    
    private func positionOfOrbitPath(index: Int) -> CGPoint {
        let angle = 2 * .pi / CGFloat(numberOfPoints) * CGFloat(index)
        let x = cos(angle) * radius + radius
        let y = sin(angle) * radius + radius
        return .init(x: x, y: y)
    }
    
    private func offsetOfMovingPoint(index: Int) -> CGSize {
        let angle = 2 * .pi / CGFloat(numberOfPoints) * CGFloat(index)
        let x = -cos(angle) * radius
        let y = -sin(angle) * radius
        return .init(width: x, height: y)
    }
}

#Preview {
    LoadingView(objectShape: Squircle(),
                pointScaleRatio: 1.5,
                addOppositeAnimation: true,
                shadowRadius: 10,
                shadowOpacity: 0.9,
                addBackground: true)
}
