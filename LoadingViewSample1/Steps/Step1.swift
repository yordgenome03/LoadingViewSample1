//
//  Step1.swift
//  LoadingViewSample1
//
//  Created by YomEngine on 2023/12/26.
//

import SwiftUI

#Preview {
    Step1_3()
}

struct Step1_1: View {
    var radius: CGFloat = 100
    var size: CGFloat { radius * 2 }

    var body: some View {
        ZStack {
            // BaseCircle（ベースの円）
            Circle()
                .stroke(lineWidth: 1)
                .frame(width: size, height: size)
            // OrbitPath（円運動の軌道：左）
            Circle()
                .fill(.black)
                .frame(width: size/10, height: size/10) // 仮
                .position(x: 0, y: radius)
            
            // OrbitPath（円運動の軌道：右）
            Circle()
                .fill(.black)
                .frame(width: size/10, height: size/10) // 仮
                .position(x: size, y: radius)
        }
    .frame(width: size, height: size)
    }
}

struct Step1_2: View {
    let radius: CGFloat = 100
    var size: CGFloat { radius * 2 }

    var body: some View {
        ZStack {
            // BaseCircle（ベースの円）
            Circle()
                .stroke(lineWidth: 1)
                .frame(width: size, height: size)
            
            ZStack {
                // OrbitPath（円運動の軌道：左）
                Circle()
                    .stroke(lineWidth: 1)
                    .frame(width: size, height: size)
                
                // MovingPoint（アニメーション）
                Circle()
                    .fill(.black)
                    .frame(width: size/10, height: size/10)
                    .offset(x: radius)
            }
            .position(x: 0, y: radius)
            
            ZStack {
                // OrbitPath（円運動の軌道：左）
                Circle()
                    .stroke(lineWidth: 1)
                    .frame(width: size, height: size)
                
                // MovingPoint（アニメーション）
                Circle()
                    .fill(.black)
                    .frame(width: size/10, height: size/10)
                    .offset(x: -radius)
            }
            .position(x: size, y: radius)
        }
        .frame(width: size, height: size)
    }
}

struct Step1_3: View {
    let radius: CGFloat = 100
    var size: CGFloat { radius * 2 }
    let animationDuration: Double = 2.0
    @State private var rotateAngle: Double = 0
    
    var body: some View {
        ZStack {
            // BaseCircle（ベースの円）
            Circle()
                .stroke(lineWidth: 1)
                .frame(width: size, height: size)
                .hidden()
            
            ZStack {
                // OrbitPath（円運動の軌道：左）
                Circle()
                    .stroke(lineWidth: 1)
                    .frame(width: size, height: size)
                    .hidden()
                
                // MovingPoint（アニメーション）
                Circle()
                    .fill(.black)
                    .frame(width: size/10, height: size/10)
                    .offset(x: radius)
            }
            .rotationEffect(.degrees(rotateAngle))
            .position(x: 0, y: radius)
            
            ZStack {
                // OrbitPath（円運動の軌道：右）
                Circle()
                    .stroke(lineWidth: 1)
                    .frame(width: size, height: size)
                    .opacity(0)
                // MovingPoint（アニメーション）
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
