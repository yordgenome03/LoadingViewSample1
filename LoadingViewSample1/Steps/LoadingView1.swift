//
//  LoadingView1.swift
//  LoadingViewSample1
//
//  Created by YomEngine on 2023/12/26.
//

import SwiftUI

struct LoadingView1: View {
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
            
            // 子円（左）
            ZStack {
                // 子円
                Circle()
                    .stroke(lineWidth: 1)
                    .frame(width: size, height: size)
                    .hidden()
                
                // 孫円
                Circle()
                    .fill(Color.black)
                    .frame(width: size/10, height: size/10)
                    .offset(x: radius)
            }
            .rotationEffect(.degrees(rotateAngle))
            .position(x: 0, y: radius)
            
            // 子円（右）
            ZStack {
                // 子円
                Circle()
                    .stroke(lineWidth: 1)
                    .frame(width: size, height: size)
                    .hidden()
                // 孫円
                Circle()
                    .fill(Color.black)
                    .frame(width: size/10, height: size/10)
                    .offset(x: -radius)
            }
            .rotationEffect(.degrees(rotateAngle))
            .position(x: size, y: radius)
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                rotateAngle = 360
            }
        }
    }
}

struct LoadingView1_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView1()
    }
}
