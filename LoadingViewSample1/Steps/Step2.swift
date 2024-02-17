//
//  Step2.swift
//  LoadingViewSample1
//
//  Created by YomEngine on 2023/12/26.
//

import SwiftUI

#Preview {
    Step2_4()
}

struct Step2_1: View {
    let radius: CGFloat = 100
    var size: CGFloat { radius * 2 }
    
    var body: some View {
        ZStack {
            // BaseCircle
            Circle()
                .stroke(lineWidth: 1)
                .frame(width: size, height: size)
            
            // OrbitPath（頂点）
            Circle()
                .fill(.red) // 基準の目印：赤
                .frame(width: size/10, height: size/10)
                .position(positionOfOrbitPath(index: 0))
            
            // OrbitPath（右下）
            Circle()
                .fill(.black)
                .frame(width: size/10, height: size/10)
                .position(positionOfOrbitPath(index: 1))
            
            // OrbitPath（左下）
            Circle()
                .fill(.black)
                .frame(width: size/10, height: size/10)
                .position(positionOfOrbitPath(index: 2))
        }
        .frame(width: size, height: size)
    }
    
    // indexRange(0...2)
    func positionOfOrbitPath(index: Int) -> CGPoint {
        let radian = (2 * Double.pi) / 3 * Double(index)
        let x = cos(radian) * radius + radius
        let y = sin(radian) * radius + radius
        return .init(x: x, y: y)
    }
}

struct Step2_2: View {
    let radius: CGFloat = 100
    var size: CGFloat { radius * 2 }
    
    var body: some View {
        ZStack {
            // BaseCircle
            Circle()
                .stroke(lineWidth: 1)
                .frame(width: size, height: size)
            
            // OrbitPath（頂点）
            Circle()
                .fill(.red) // 基準の目印：赤
                .frame(width: size/10, height: size/10)
                .position(positionOfOrbitPath(index: 0))
                .rotationEffect(.degrees(-90))

            // OrbitPath（右下）
            Circle()
                .fill(.black)
                .frame(width: size/10, height: size/10)
                .position(positionOfOrbitPath(index: 1))
                .rotationEffect(.degrees(-90))

            // OrbitPath（左下）
            Circle()
                .fill(.black)
                .frame(width: size/10, height: size/10)
                .position(positionOfOrbitPath(index: 2))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: size, height: size)
    }
    
    // indexRange(0...2)
    func positionOfOrbitPath(index: Int) -> CGPoint {
        let radian = (2 * Double.pi) / 3 * Double(index)
        let x = cos(radian) * radius + radius
        let y = sin(radian) * radius + radius
        return .init(x: x, y: y)
    }
}

struct Step2_3: View {
    let radius: CGFloat = 100
    var size: CGFloat { radius * 2 }
    
    var body: some View {
        ZStack {
            // BaseCircle
            Circle()
                .stroke(lineWidth: 1)
                .frame(width: size, height: size)
            
            // 頂点
            ZStack {
                // OrbitPath
                Circle()
                    .stroke(lineWidth: 1)
                    .frame(width: size, height: size)
                
                // MovingPoint
                Circle()
                    .fill(Color.red)
                    .frame(width: size/10, height: size/10)
                    .offset(offsetOfMovingPoint(index: 0))
            }
            .position(positionOfOrbitPath(index: 0))
            .rotationEffect(.degrees(-90))
            
            // 右下
            ZStack {
                // OrbitPath
                Circle()
                    .stroke(lineWidth: 1)
                    .frame(width: size, height: size)
                
                // MovingPoint
                Circle()
                    .fill(Color.black)
                    .frame(width: size/10, height: size/10)
                    .offset(offsetOfMovingPoint(index: 1))
            }
            .position(positionOfOrbitPath(index: 1))
            .rotationEffect(.degrees(-90))
            
            // 左下
            ZStack {
                // OrbitPath
                Circle()
                    .stroke(lineWidth: 1)
                    .frame(width: size, height: size)
                
                // MovingPoint
                Circle()
                    .fill(Color.black)
                    .frame(width: size/10, height: size/10)
                    .offset(offsetOfMovingPoint(index: 2))
            }
            .position(positionOfOrbitPath(index: 2))
            .rotationEffect(.degrees(-90))
        }
        .frame(width: size, height: size)
    }
    
    // indexRange(0...2)
    private func positionOfOrbitPath(index: Int) -> CGPoint {
        let radian = (2 * Double.pi) / 3 * Double(index)
        let x = cos(radian) * radius + radius
        let y = sin(radian) * radius + radius
        return .init(x: x, y: y)
    }
    
    // indexRange(0...2)
    private func offsetOfMovingPoint(index: Int) -> CGSize {
        let radian = (2 * Double.pi) / 3 * Double(index)
        let x = -cos(radian) * radius
        let y = -sin(radian) * radius
        return .init(width: x, height: y)
    }
}

struct Step2_4: View {
    let radius: CGFloat = 100
    var size: CGFloat { radius * 2 }
    let animationDuration: Double = 2.0
    @State private var rotateAngle: Double = 0

    var body: some View {
        ZStack {
            // BaseCircle
            Circle()
                .stroke(lineWidth: 1)
                .frame(width: size, height: size)
                .hidden()

            // 頂点
            ZStack {
                // OrbitPath
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: size, height: size)
                    .hidden()

                // MovingPoint
                Circle()
                    .fill(Color.red)
                    .frame(width: size/10, height: size/10)
                    .offset(positionOfMovingPoint(index: 0))
            }
            .rotationEffect(.degrees(rotateAngle))
            .position(positionOfOrbitPath(index: 0))
            .rotationEffect(.degrees(-90))

            // 右下
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
                    .offset(positionOfMovingPoint(index: 1))
            }
            .rotationEffect(.degrees(rotateAngle))
            .position(positionOfOrbitPath(index: 1))
            .rotationEffect(.degrees(-90))
            
            // 左下
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
                    .offset(positionOfMovingPoint(index: 2))
            }
            .rotationEffect(.degrees(rotateAngle))
            .position(positionOfOrbitPath(index: 2))
            .rotationEffect(.degrees(-90))
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                rotateAngle = 360
            }
        }
    }
    
    // indexRange(0...2)
    private func positionOfOrbitPath(index: Int) -> CGPoint {
        let radian = (2 * Double.pi) / 3 * Double(index)
        let x = cos(radian) * radius + radius
        let y = sin(radian) * radius + radius
        return .init(x: x, y: y)
    }
    
    // indexRange(0...2)
    private func positionOfMovingPoint(index: Int) -> CGSize {
        let radian = (2 * Double.pi) / 3 * Double(index)
        let x = -cos(radian) * radius
        let y = -sin(radian) * radius
        return .init(width: x, height: y)
    }
}
