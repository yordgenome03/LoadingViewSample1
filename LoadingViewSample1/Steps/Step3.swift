//
//  Step3.swift
//  LoadingViewSample1
//
//  Created by YomEngine on 2023/12/26.
//

import SwiftUI
import Combine

#Preview {
    Step3_3()
}

struct Step3_1: View {
    let radius: CGFloat = 100
    var size: CGFloat { radius * 2 }
    let animationDuration: Double = 2.0
    let numberOfPoints: Int = 5
    @State private var rotateAngle: Double = 0
    
    var body: some View {
        ZStack {
            // BaseCircle
            Circle()
                .stroke(lineWidth: 1)
                .frame(width: size, height: size)
                .hidden()
            
            ForEach((0..<numberOfPoints), id: \.self) { index in
                ZStack {
                    // OrbitPath
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: size, height: size)
                        .hidden()

                    // MovingPoint
                    Circle()
                        .fill(Color.black)
                        .frame(width: size/10, height: size/10)
                        .offset(offsetOfMovingPoint(index: index))
                }
                .rotationEffect(.degrees(rotateAngle))
                .position(positionOfOrbitPath(index: index))
                .rotationEffect(.degrees(-90))
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                rotateAngle = 360
            }
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

struct Step3_2: View {
    var radius: CGFloat = 100
    var size: CGFloat { radius * 2 }
    var animationDuration: Double = 2.0
    var numberOfPoints: Int = 5
    @State var rotateAngle: Double = 0
    
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
            withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                rotateAngle = 360
            }
        }
    }
    
    private func MovingPoint(index: Int) -> some View {
        ZStack {
            Circle()
                .fill(Color.black)
                .frame(width: size/10, height: size/10)
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

struct Step3_3: View {
    let radius: CGFloat = 100
    var size: CGFloat { radius * 2 }
    let animationDuration: Double = 2.0
    let numberOfPoints: Int = 5
    @State private var rotateAngle: Double = 0
    let colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    
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
            withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                rotateAngle = 360
            }
        }
    }
    
    @ViewBuilder
    private func MovingPoint(index: Int) -> some View {
        ZStack {
            Circle()
                .fill(colors[index % colors.count])
                .frame(width: size/10, height: size/10)
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

struct Step3_4: View {
    let radius: CGFloat = 100
    var size: CGFloat { radius * 2 }
    let animationDuration: Double = 2.0
    let numberOfPoints: Int = 5
    @State private var rotateAngle: Double = 0
    let colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    var pointSize: CGFloat {
        radius * 0.2
    }
    
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
            withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                rotateAngle = 360
            }
        }
    }
    
    @ViewBuilder
    private func MovingPoint(index: Int) -> some View {
        ZStack {
            Circle()
                .fill(colors[index % colors.count])
                .frame(width: pointSize, height: pointSize)
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

