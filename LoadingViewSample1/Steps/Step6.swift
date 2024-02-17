//
//  Step6.swift
//  LoadingViewSample1
//
//  Created by YomEngine on 2023/12/28.
//

import SwiftUI
import Combine

struct Sample_Step6<T: Shape>: View {
    let objectShape: T
    let frameSize: CGFloat = 300
    var radius: CGFloat { frameSize / 5 }
    var size: CGFloat { radius * 2 }
    let animationDuration: Double = 2.0
    let numberOfPoints: Int = 5
    let colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    var pointSize: CGFloat { radius * 0.2 }
    @State private var rotateAngle: Double = 0
    @State private var pointScale: CGFloat = 1.0
    @State private var timer: AnyCancellable?
    let addOppositeAnimation: Bool = true
    let shadowRadius: CGFloat = 20
    let shadowOffset: CGFloat = 20
    var backgroundCornerRadius: CGFloat { frameSize / 10 }
    let backgroundOpacity: CGFloat = 0.3
    let addBackground: Bool = true
    
    init(objectShape: T = Circle()) {
        self.objectShape = objectShape
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
                }
            }
            .frame(width: size, height: size)
            .onAppear {
                let animationSteps: CGFloat = 36
                timer = Timer.publish(every: animationDuration / animationSteps, on: .main, in: .default)
                    .autoconnect()
                    .sink { _ in
                        withAnimation(.linear) {
                            rotateAngle += (360.0 / animationSteps)
                            
                            let baseScale = 1.0
                            let scaleOffset = rotateAngle < 180
                            ? CGFloat(rotateAngle) / 180
                            : CGFloat(360 - rotateAngle) / 180
                            pointScale = baseScale + scaleOffset
                        }
                        
                        if rotateAngle >= 360 {
                            rotateAngle = 0
                        }
                    }
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
    
    func shadowRadius(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let shadowRadiusRatio = isOpposite
        ? 1.0 - (pointScale - 1.0)
        : pointScale - 1.0
        return value * shadowRadiusRatio
    }
    
    func shadowOffset(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let shadowOffsetRatio = isOpposite
        ? -(1.0 - (pointScale - 1.0))
        : pointScale - 1.0
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
    Step6_4(objectShape: Rectangle())
        .border(.black)
}

struct Step6_1: View {
    let frameSize: CGFloat = 400
    var radius: CGFloat { frameSize / 4 }
    var size: CGFloat { radius * 2 }
    let animationDuration: Double = 2.0
    let numberOfPoints: Int = 5
    let colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    var pointSize: CGFloat {
        radius * 0.2
    }
    @State private var rotateAngle: Double = 0
    @State private var pointScale: CGFloat = 1.0
    @State private var timer: AnyCancellable?
    let addOppositeAnimation: Bool = true
    let shadowRadius: CGFloat = 20
    let shadowOffset: CGFloat = 20

    var body: some View {
        ZStack {
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
                }
            }
            .frame(width: size, height: size)
            .onAppear {
                let animationSteps: CGFloat = 36
                timer = Timer.publish(every: animationDuration / animationSteps, on: .main, in: .default)
                    .autoconnect()
                    .sink { _ in
                        withAnimation(.linear) {
                            rotateAngle += (360.0 / animationSteps)
                            
                            let baseScale = 1.0
                            let scaleOffset = rotateAngle < 180
                            ? CGFloat(rotateAngle) / 180
                            : CGFloat(360 - rotateAngle) / 180
                            pointScale = baseScale + scaleOffset
                        }
                        
                        if rotateAngle >= 360 {
                            rotateAngle = 0
                        }
                    }
            }
        }
        .frame(width: frameSize, height: frameSize)
    }
    
    @ViewBuilder
    private func MovingPoint(index: Int, isOpposite: Bool) -> some View {
        ZStack {
            Circle()
                .fill(colors[index % colors.count])
                .frame(width: pointSize, height: pointSize)
                .scaleEffect(pointScale)
                .offset(offsetOfMovingPoint(index: index))
                .animation(.linear.delay(isOpposite ?  animationDuration/2 : 0), value: pointScale)
        }
    }
    
    func shadowRadius(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let shadowRadiusRatio = isOpposite
        ? 1.0 - (pointScale - 1.0)
        : pointScale - 1.0
        return value * shadowRadiusRatio
    }
    
    func shadowOffset(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let shadowOffsetRatio = isOpposite
        ? -(1.0 - (pointScale - 1.0))
        : pointScale - 1.0
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

struct Step6_2: View {
    let frameSize: CGFloat = 300
    var radius: CGFloat { frameSize / 5 }
    var size: CGFloat { radius * 2 }
    let animationDuration: Double = 2.0
    let numberOfPoints: Int = 5
    let colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    var pointSize: CGFloat {
        radius * 0.2
    }
    @State private var rotateAngle: Double = 0
    @State private var pointScale: CGFloat = 1.0
    @State private var timer: AnyCancellable?
    let addOppositeAnimation: Bool = true
    let shadowRadius: CGFloat = 20
    let shadowOffset: CGFloat = 20

    var body: some View {
        ZStack {
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
                }
            }
            .frame(width: size, height: size)
            .onAppear {
                let animationSteps: CGFloat = 36
                timer = Timer.publish(every: animationDuration / animationSteps, on: .main, in: .default)
                    .autoconnect()
                    .sink { _ in
                        withAnimation(.linear) {
                            rotateAngle += (360.0 / animationSteps)
                            
                            let baseScale = 1.0
                            let scaleOffset = rotateAngle < 180
                            ? CGFloat(rotateAngle) / 180
                            : CGFloat(360 - rotateAngle) / 180
                            pointScale = baseScale + scaleOffset
                        }
                        
                        if rotateAngle >= 360 {
                            rotateAngle = 0
                        }
                    }
            }
        }
        .frame(width: frameSize, height: frameSize)
    }
    
    @ViewBuilder
    private func MovingPoint(index: Int, isOpposite: Bool) -> some View {
        ZStack {
            Circle()
                .fill(colors[index % colors.count])
                .frame(width: pointSize, height: pointSize)
                .scaleEffect(pointScale)
                .offset(offsetOfMovingPoint(index: index))
                .animation(.linear.delay(isOpposite ?  animationDuration/2 : 0), value: pointScale)
        }
    }
    
    func shadowRadius(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let shadowRadiusRatio = isOpposite
        ? 1.0 - (pointScale - 1.0)
        : pointScale - 1.0
        return value * shadowRadiusRatio
    }
    
    func shadowOffset(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let shadowOffsetRatio = isOpposite
        ? -(1.0 - (pointScale - 1.0))
        : pointScale - 1.0
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

struct Step6_3: View {
    let frameSize: CGFloat = 300
    var radius: CGFloat { frameSize / 5 }
    var size: CGFloat { radius * 2 }
    let animationDuration: Double = 2.0
    let numberOfPoints: Int = 5
    let colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    var pointSize: CGFloat { radius * 0.2 }
    @State private var rotateAngle: Double = 0
    @State private var pointScale: CGFloat = 1.0
    @State private var timer: AnyCancellable?
    let addOppositeAnimation: Bool = true
    let shadowRadius: CGFloat = 20
    let shadowOffset: CGFloat = 20
    var backgroundCornerRadius: CGFloat { frameSize / 10 }
    let backgroundOpacity: CGFloat = 0.3
    let addBackground: Bool = true
    
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
                }
            }
            .frame(width: size, height: size)
            .onAppear {
                let animationSteps: CGFloat = 36
                timer = Timer.publish(every: animationDuration / animationSteps, on: .main, in: .default)
                    .autoconnect()
                    .sink { _ in
                        withAnimation(.linear) {
                            rotateAngle += (360.0 / animationSteps)
                            
                            let baseScale = 1.0
                            let scaleOffset = rotateAngle < 180
                            ? CGFloat(rotateAngle) / 180
                            : CGFloat(360 - rotateAngle) / 180
                            pointScale = baseScale + scaleOffset
                        }
                        
                        if rotateAngle >= 360 {
                            rotateAngle = 0
                        }
                    }
            }
        }
        .frame(width: frameSize, height: frameSize)
    }
    
    @ViewBuilder
    private func MovingPoint(index: Int, isOpposite: Bool) -> some View {
        ZStack {
            Circle()
                .fill(colors[index % colors.count])
                .frame(width: pointSize, height: pointSize)
                .scaleEffect(pointScale)
                .offset(offsetOfMovingPoint(index: index))
                .animation(.linear.delay(isOpposite ?  animationDuration/2 : 0), value: pointScale)
        }
    }
    
    func shadowRadius(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let shadowRadiusRatio = isOpposite
        ? 1.0 - (pointScale - 1.0)
        : pointScale - 1.0
        return value * shadowRadiusRatio
    }
    
    func shadowOffset(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let shadowOffsetRatio = isOpposite
        ? -(1.0 - (pointScale - 1.0))
        : pointScale - 1.0
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

struct Step6_4<T: Shape>: View {
    let objectShape: T
    let frameSize: CGFloat = 300
    var radius: CGFloat { frameSize / 5 }
    var size: CGFloat { radius * 2 }
    let animationDuration: Double = 2.0
    let numberOfPoints: Int = 5
    let colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    var pointSize: CGFloat { radius * 0.2 }
    @State private var rotateAngle: Double = 0
    @State private var pointScale: CGFloat = 1.0
    @State private var timer: AnyCancellable?
    let addOppositeAnimation: Bool = true
    let shadowRadius: CGFloat = 20
    let shadowOffset: CGFloat = 20
    var backgroundCornerRadius: CGFloat { frameSize / 10 }
    let backgroundOpacity: CGFloat = 0.3
    let addBackground: Bool = true
    
    init(objectShape: T = Circle()) {
        self.objectShape = objectShape
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
                }
            }
            .frame(width: size, height: size)
            .onAppear {
                let animationSteps: CGFloat = 36
                timer = Timer.publish(every: animationDuration / animationSteps, on: .main, in: .default)
                    .autoconnect()
                    .sink { _ in
                        withAnimation(.linear) {
                            rotateAngle += (360.0 / animationSteps)
                            
                            let baseScale = 1.0
                            let scaleOffset = rotateAngle < 180
                            ? CGFloat(rotateAngle) / 180
                            : CGFloat(360 - rotateAngle) / 180
                            pointScale = baseScale + scaleOffset
                        }
                        
                        if rotateAngle >= 360 {
                            rotateAngle = 0
                        }
                    }
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
    
    func shadowRadius(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let shadowRadiusRatio = isOpposite
        ? 1.0 - (pointScale - 1.0)
        : pointScale - 1.0
        return value * shadowRadiusRatio
    }
    
    func shadowOffset(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let shadowOffsetRatio = isOpposite
        ? -(1.0 - (pointScale - 1.0))
        : pointScale - 1.0
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
