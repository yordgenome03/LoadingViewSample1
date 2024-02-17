//
//  Sample_Step3.swift
//  LoadingViewSample1
//
//  Created by YomEngine on 2023/12/26.
//

import SwiftUI
import Combine

#Preview {
    Step4_3()
}

struct Step4_1: View {
    let radius: CGFloat = 100
    var size: CGFloat { radius * 2 }
    let animationDuration: Double = 2.0
    let numberOfPoints: Int = 5
    @State private var rotateAngle: Double = 0
    let colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    var pointSize: CGFloat {
        radius * 0.2
    }
    @State private var pointScale: CGFloat = 1.0

    
    var body: some View {
        ZStack {
            ForEach((0..<numberOfPoints), id: \.self) { index in
                MovingPoint(index: index)
                .rotationEffect(.degrees(rotateAngle))
                .position(positionOfOrbitPath(index: index))
                .rotationEffect(.degrees(-90))
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            // 回転アニメーション
            withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                rotateAngle = 360
            }
            
            // 拡大縮小アニメーション
            withAnimation(.linear(duration: animationDuration/2).repeatForever(autoreverses: true)) {
                pointScale = 1.8
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

struct Step4_2: View {
    let radius: CGFloat = 100
    var size: CGFloat { radius * 2 }
    let animationDuration: Double = 2.0
    let numberOfPoints: Int = 5
    @State private var rotateAngle: Double = 0
    let colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    var pointSize: CGFloat {
        radius * 0.2
    }
    @State private var pointScale: CGFloat = 1.0
    @State private var timer: AnyCancellable?
    
    var body: some View {
        ZStack {
            ForEach((0..<numberOfPoints), id: \.self) { index in
                MovingPoint(index: index)
                .rotationEffect(.degrees(rotateAngle))
                .position(positionOfOrbitPath(index: index))
                .rotationEffect(.degrees(-90))
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

struct Step4_3: View {
    let radius: CGFloat = 100
    var size: CGFloat { radius * 2 }
    let animationDuration: Double = 2.0
    let numberOfPoints: Int = 5
    @State private var rotateAngle: Double = 0
    let colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    var pointSize: CGFloat {
        radius * 0.2
    }
    @State private var pointScale: CGFloat = 1.0
    @State private var timer: AnyCancellable?
    
    var body: some View {
        ZStack {
            ForEach((0..<numberOfPoints), id: \.self) { index in
                MovingPoint(index: index)
                .rotationEffect(.degrees(rotateAngle))
                .position(positionOfOrbitPath(index: index))
                .rotationEffect(.degrees(-90))
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
