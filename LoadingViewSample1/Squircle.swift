//
//  Squircle.swift
//  LoadingViewSample1
//
//  Created by YomEngine on 2023/12/26.
//

import SwiftUI

struct Squircle: Shape {
    // 0...1
    var cornerRadiusRatio: CGFloat = 0.6

    func path(in rect: CGRect) -> Path {
        let cornerRadius: CGFloat = rect.width * cornerRadiusRatio
        
        let minSide = min(rect.width, rect.height)
        let radius = min(cornerRadius, minSide/2)

        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)

        let p0 = CGPoint(x: rect.minX + radius, y: rect.minY)
        let p1 = CGPoint(x: rect.maxX - radius, y: rect.minY)
        let p2 = CGPoint(x: rect.maxX, y: rect.minY + radius)
        let p3 = CGPoint(x: rect.maxX, y: rect.maxY - radius)
        let p4 = CGPoint(x: rect.maxX - radius, y: rect.maxY)
        let p5 = CGPoint(x: rect.minX + radius, y: rect.maxY)
        let p6 = CGPoint(x: rect.minX, y: rect.maxY - radius)
        let p7 = CGPoint(x: rect.minX, y: rect.minY + radius)

        var path = Path()
        path.move(to: p0)
        path.addLine(to: p1)
        path.addQuadCurve(to: p2, control: topRight)
        path.addLine(to: p3)
        path.addQuadCurve(to: p4, control: bottomRight)
        path.addLine(to: p5)
        path.addQuadCurve(to: p6, control: bottomLeft)
        path.addLine(to: p7)
        path.addQuadCurve(to: p0, control: topLeft)

        return path
    }
}

#Preview {
    Squircle()
        .fill(Color.blue.gradient)
        .frame(width: 100, height: 100)
}
