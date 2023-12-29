//
//  LoadingView3.swift
//  LoadingViewSample1
//
//  Created by YomEngine on 2023/12/26.
//

import SwiftUI
import Combine

struct LoadingView3: View {
    var radius: CGFloat = 100
    var size: CGFloat { radius * 2 }
    var animationDuration: Double = 2.0
    var numberOfPoints: Int = 5
    var colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    var pointSize: CGFloat {
        radius * 0.2
    }
    @State private var rotateAngle: Double = 0
    @State private var pointScale: CGFloat = 1.0
    @State private var timer: AnyCancellable?
    
    var body: some View {
        ZStack {
            // 親円
            Circle()
                .stroke(lineWidth: 1)
                .frame(width: size, height: size)
                .opacity(0)
            
            ForEach(0..<numberOfPoints, id: \.self) { index in
                // 子円
                ChildView(index: index)
                    .rotationEffect(.degrees(rotateAngle))
                    .position(childPosition(index: index))
                    .rotationEffect(.degrees(-90))
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            timer = Timer.publish(every: animationDuration / 360, on: .main, in: .default)
                .autoconnect()
                .sink { _ in
                    withAnimation(.linear) {
                        self.rotateAngle += 1.0
                        
                        let baseScale = 1.0
                        let rotatedAngle = Int(self.rotateAngle) % 360
                        let scaleOffset = rotatedAngle < 180
                        ? CGFloat(rotatedAngle) / 180
                        : CGFloat(360 - rotatedAngle) / 180
                        self.pointScale = baseScale + scaleOffset
                    }
                }
        }
    }
    
    @ViewBuilder
    private func ChildView(index: Int) -> some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 2)
                .frame(width: size, height: size)
                .opacity(0)
            // 孫円
            Circle()
                .fill(colors[index % colors.count])
                .frame(width: pointSize, height: pointSize)
                .scaleEffect(pointScale)
                .offset(grandChildOffset(index: index))
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

struct LoadingView3_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView3()
    }
}
