//
//  LoadingView.swift
//  LoadingViewSample1
//
//  Created by YomEngine on 2023/12/28.
//

import SwiftUI
import Combine

struct LoadingView<T: Shape>: View {
    private let objectShape: T
    private let frameSize: CGFloat
    private var radius: CGFloat {
        frameSize / 5
    }
    private var size: CGFloat { radius * 2 }
    private let animationDuration: Double
    private let numberOfPoints: Int
    private let colors: [Color] = [.red, .purple, .blue, .green, .yellow, .orange]
    private var pointSize: CGFloat {
        radius * 0.2
    }
    private let baseScale: CGFloat
    @State private var pointScale: CGFloat = 1.0

    private let shadowOpacity: CGFloat
    private let shadowRadius: CGFloat
    private let shadowOffset: CGFloat
    private var addOppositeAnimation: Bool
    private let addBackground: Bool
    private var backgroundCornerRadius: CGFloat {
        frameSize / 10
    }
    private var backgroundOpacity: CGFloat
    @State private var rotateAngle: Double = 0
    @State private var timer: AnyCancellable?
    
    init(objectShape: T = Circle(),
         frameSize: CGFloat = 300,
         animationDuration: Double = 2.0,
         numberOfPoints: Int = 5,
         pointScale: CGFloat = 1.0,
         addOppositeAnimation: Bool = false,
         addBackground: Bool = false,
         backgroundOpacity: CGFloat = 0.3,
         shadowOpacity: CGFloat = 0.5,
         shadowRadius: CGFloat = 20,
         shadowOffset: CGFloat = 20
    ) {
        self.frameSize = frameSize
        self.animationDuration = animationDuration
        self.numberOfPoints = numberOfPoints
        self.baseScale = pointScale
        self.objectShape = objectShape
        self.addOppositeAnimation = addOppositeAnimation
        self.addBackground = addBackground
        self.backgroundOpacity = backgroundOpacity
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
    }
    
    var body: some View {
        
        ZStack {
            if addBackground {
                RoundedRectangle(cornerRadius: backgroundCornerRadius)
                    .background(.ultraThinMaterial)
                    .opacity(backgroundOpacity)
                    .shadow(radius: 20)
            }
            
            ZStack {
                ForEach(0..<numberOfPoints, id: \.self) { index in
                    ChildView(index: index)
                        .rotationEffect(.degrees(rotateAngle))
                        .position(childPosition(index: index))
                        .rotationEffect(.degrees(-90))
                        .shadow(color: colors[index % colors.count].opacity(shadowOpacity),
                                radius: shadowRadius(shadowRadius),
                                y: shadowOffset(shadowOffset))
                }
                
                if addOppositeAnimation {
                    ForEach(0..<numberOfPoints, id: \.self) { index in
                        ChildView(index: index, isOpposite: true)
                            .rotationEffect(.degrees(-rotateAngle + 180))
                            .position(childPosition(index: index))
                            .rotationEffect(.degrees(-90))
                            .shadow(color: colors[index % colors.count].opacity(0.5),
                                    radius: shadowRadius(shadowRadius, isOpposite: true),
                                    y: shadowOffset(shadowOffset, isOpposite: true))
                    }
                    .rotationEffect(.degrees(180))
                }
            }
            .frame(width: size, height: size)
            .onAppear {
                timer = Timer.publish(every: animationDuration / 360, on: .main, in: .default)
                    .autoconnect()
                    .sink { _ in
                        withAnimation(.linear) {
                            rotateAngle += 1.0
                            
                            let rotatedAngle = Int(rotateAngle) % 360
                            let scaleOffset = rotatedAngle < 180
                            ? CGFloat(rotatedAngle) / 180
                            : CGFloat(360 - rotatedAngle) / 180
                            pointScale = baseScale + scaleOffset
                        }
                    }
            }
        }
        .frame(width: frameSize, height: frameSize)
    }
    
    private func shadowRadius(_ value: CGFloat, isOpposite: Bool = false) -> CGFloat {
        let shadowRadiusRatio = isOpposite
        ? 1.0 - (pointScale - 1.0)
        : pointScale - 1.0
        return value * shadowRadiusRatio
    }
    
    private func shadowOffset(_ value: CGFloat, isOpposite: Bool = false) -> CGFloat {
        let shadowOffsetRatio = isOpposite
        ? -(1.0 - (pointScale - 1.0))
        : pointScale - 1.0
        return value * shadowOffsetRatio
    }
    
    @ViewBuilder
    private func ChildView(index: Int, isOpposite: Bool = false) -> some View {
        ZStack {
            objectShape
                .fill(colors[index % colors.count])
                .frame(width: pointSize, height: pointSize)
                .scaleEffect(pointScale)
                .offset(grandChildOffset(index: index))
                .animation(.linear.delay(isOpposite ?  animationDuration/2 : 0), value: pointScale)
        }
    }
    
    private func childPosition(index: Int) -> CGPoint {
        let angle = 2 * .pi / CGFloat(numberOfPoints) * CGFloat(index)
        let x = cos(angle) * radius + radius
        let y = sin(angle) * radius + radius
        return .init(x: x, y: y)
    }
    
    private func grandChildOffset(index: Int) -> CGSize {
        let angle = 2 * .pi / CGFloat(numberOfPoints) * CGFloat(index)
        let x = -cos(angle) * radius
        let y = -sin(angle) * radius
        return .init(width: x, height: y)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
