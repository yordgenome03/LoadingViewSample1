//
//  Step5.swift
//  LoadingViewSample1
//
//  Created by YomEngine on 2023/12/28.
//

import SwiftUI
import Combine

#Preview {
    Step5_2()
}

struct Sample_Step5: View {
    let radius: CGFloat = 100
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

struct Step5_1: View {
    let radius: CGFloat = 100
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

    var body: some View {
        ZStack {
            ForEach(0..<numberOfPoints, id: \.self) { index in
                MovingPoint(index: index)
                    .rotationEffect(.degrees(rotateAngle))
                    .position(positionOfOrbitPath(index: index))
                    .rotationEffect(.degrees(-90))
            }
            
            if addOppositeAnimation {
                ForEach(0..<numberOfPoints, id: \.self) { index in
                    MovingPoint(index: index)
                        .rotationEffect(.degrees(rotateAngle))
                        .position(positionOfOrbitPath(index: index))
                        .rotationEffect(.degrees(-90))
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
    
    @ViewBuilder
    private func MovingPoint(index: Int) -> some View {
        ZStack {
            Circle()
                .fill(colors[index % colors.count])
                .frame(width: pointSize, height: pointSize)
                .scaleEffect(pointScale)
                .offset(offsetOfMovingPoint(index: index))
        }
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

struct Step5_2: View {
    let radius: CGFloat = 100
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

    var body: some View {
        ZStack {
            ForEach(0..<numberOfPoints, id: \.self) { index in
                MovingPoint(index: index, isOpposite: false)
                    .rotationEffect(.degrees(rotateAngle))
                    .position(positionOfOrbitPath(index: index))
                    .rotationEffect(.degrees(-90))
            }
            
            if addOppositeAnimation {
                ForEach(0..<numberOfPoints, id: \.self) { index in
                    MovingPoint(index: index, isOpposite: true)
                        .rotationEffect(.degrees(rotateAngle + 180))
                        .position(positionOfOrbitPath(index: index))
                        .rotationEffect(.degrees(-90))
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

struct Step5_3: View {
    let radius: CGFloat = 100
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

    var body: some View {
        ZStack {
            ForEach(0..<numberOfPoints, id: \.self) { index in
                MovingPoint(index: index, isOpposite: false)
                    .rotationEffect(.degrees(rotateAngle))
                    .position(positionOfOrbitPath(index: index))
                    .rotationEffect(.degrees(-90))
            }
            
            if addOppositeAnimation {
                ForEach(0..<numberOfPoints, id: \.self) { index in
                    MovingPoint(index: index, isOpposite: true)
                        .rotationEffect(.degrees(-rotateAngle + 180))
                        .position(positionOfOrbitPath(index: index))
                        .rotationEffect(.degrees(-90))
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

struct Step5_4: View {
    let radius: CGFloat = 100
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
