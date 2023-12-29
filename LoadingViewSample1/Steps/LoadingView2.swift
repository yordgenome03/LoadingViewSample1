//
//  LoadingView2.swift
//  LoadingViewSample1
//
//  Created by YomEngine on 2023/12/26.
//

import SwiftUI

struct LoadingView2: View {
    var radius: CGFloat = 100
    var size: CGFloat { radius * 2 }
    var animationDuration: Double = 2.0
    @State var rotateAngle: Double = 0

    var body: some View {
        ZStack {
            // 親円
            Circle()
                .stroke(lineWidth: 1)
                .frame(width: size, height: size)
                .hidden()

            // 子円（頂点）
            ZStack {
                // 子円
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: size, height: size)
                    .hidden()

                // 孫円
                Circle()
                    .fill(Color.red)
                    .frame(width: size/10, height: size/10)
                    .offset(grandChildOffset(index: 0))
            }
            .rotationEffect(.degrees(rotateAngle))
            .position(childPosition(index: 0))
            .rotationEffect(.degrees(-90))

            // 子円（右下）
            ZStack {
                // 子円
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: size, height: size)
                    .hidden()

                // 孫円
                Circle()
                    .fill(Color.black)
                    .frame(width: size/10, height: size/10)
                    .offset(grandChildOffset(index: 1))
            }
            .rotationEffect(.degrees(rotateAngle))
            .position(childPosition(index: 1))
            .rotationEffect(.degrees(-90))
            
            // 子円（左下）
            ZStack {
                // 子円
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: size, height: size)
                    .hidden()

                // 孫円
                Circle()
                    .fill(Color.black)
                    .frame(width: size/10, height: size/10)
                    .offset(grandChildOffset(index: 2))
            }
            .rotationEffect(.degrees(rotateAngle))
            .position(childPosition(index: 2))
            .rotationEffect(.degrees(-90))
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                rotateAngle = 360
            }
        }
    }
    
    // 0...2
    func childPosition(index: Int) -> CGPoint {
        let radian = (2 * Double.pi) / 3 * Double(index)
        let x = cos(radian) * radius + radius
        let y = sin(radian) * radius + radius
        return .init(x: x, y: y)
    }
    
    // 0...2
    func grandChildOffset(index: Int) -> CGSize {
        let radian = (2 * Double.pi) / 3 * Double(index)
        let x = -cos(radian) * radius
        let y = -sin(radian) * radius
        return .init(width: x, height: y)
    }
}

struct LoadingView2_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView2()
    }
}
