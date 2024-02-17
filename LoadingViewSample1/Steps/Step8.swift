//
//  Step8.swift
//  LoadingViewSample1
//
//  Created by YomEngine on 2023/12/28.
//

import SwiftUI
import Combine

#Preview {
    PreviewView12()
}

struct Step8_1<T: Shape>: View {
    let objectShape: T
    let frameSize: CGFloat
    var radius: CGFloat { frameSize / 5 }
    var size: CGFloat { radius * 2 }
    let animationDuration: Double
    let numberOfPoints: Int
    let colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    var pointSize: CGFloat { radius * 0.2 }
    @State private var rotateAngle: Double = 0
    @State private var pointScale: CGFloat = 1.0
    @State private var timer: AnyCancellable?
    let addOppositeAnimation: Bool
    let shadowRadius: CGFloat
    let shadowOffset: CGFloat
    var backgroundCornerRadius: CGFloat { frameSize / 10 }
    let backgroundOpacity: CGFloat
    let addBackground: Bool
    
    init(objectShape: T = Circle(),
         frameSize: CGFloat = 300,
         animationDuration: Double = 2.0,
         numberOfPoints: Int = 5,
         addOppositeAnimation: Bool = true,
         shadowRadius: CGFloat = 20,
         shadowOffset: CGFloat = 20,
         backgroundOpacity: CGFloat = 0.3,
         addBackground: Bool = true
    ) {
        self.objectShape = objectShape
        self.frameSize = frameSize
        self.animationDuration = animationDuration
        self.numberOfPoints = numberOfPoints
        self.addOppositeAnimation = addOppositeAnimation
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.backgroundOpacity = backgroundOpacity
        self.addBackground = addBackground
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
                .offset(y: -shadowOffset(shadowOffset, isOpposite: false))
                
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
                    .offset(y: shadowOffset(shadowOffset, isOpposite: true))
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

struct Step8_2<T: Shape>: View {
    let objectShape: T
    let frameSize: CGFloat
    var radius: CGFloat { frameSize / 5 }
    var size: CGFloat { radius * 2 }
    let animationDuration: Double
    let numberOfPoints: Int
    let colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    var pointSize: CGFloat { radius * 0.2 }
    let pointScaleRatio: CGFloat
    @State private var rotateAngle: Double = 0
    @State private var pointScale: CGFloat = 1.0
    @State private var timer: AnyCancellable?
    let addOppositeAnimation: Bool
    let shadowRadius: CGFloat
    let shadowOffset: CGFloat
    var backgroundCornerRadius: CGFloat { frameSize / 10 }
    let backgroundOpacity: CGFloat
    let addBackground: Bool
    
    init(objectShape: T = Circle(),
         frameSize: CGFloat = 300,
         animationDuration: Double = 2.0,
         numberOfPoints: Int = 5,
         pointScaleRatio: CGFloat = 1.0,
         addOppositeAnimation: Bool = true,
         shadowRadius: CGFloat = 20,
         shadowOffset: CGFloat = 20,
         backgroundOpacity: CGFloat = 0.3,
         addBackground: Bool = true
    ) {
        self.objectShape = objectShape
        self.frameSize = frameSize
        self.animationDuration = animationDuration
        self.numberOfPoints = numberOfPoints
        self.pointScaleRatio = pointScaleRatio
        self.addOppositeAnimation = addOppositeAnimation
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.backgroundOpacity = backgroundOpacity
        self.addBackground = addBackground
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
                .offset(y: -shadowOffset(shadowOffset, isOpposite: false))
                
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
                    .offset(y: shadowOffset(shadowOffset, isOpposite: true))
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
                            pointScale = pointScaleRatio * (baseScale + scaleOffset)
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
    
    private func shadowRadius(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let scale = pointScale / pointScaleRatio
        let shadowRadiusRatio = isOpposite
        ? 1.0 - (scale - 1.0)
        : scale - 1.0
        return value * shadowRadiusRatio
    }
    
    private func shadowOffset(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let scale = pointScale / pointScaleRatio
        let shadowOffsetRatio = isOpposite
        ? -(1.0 - (scale - 1.0))
        : scale - 1.0
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

struct Step8_3<T: Shape>: View {
    let objectShape: T
    let frameSize: CGFloat
    var radius: CGFloat { frameSize / 5 }
    var size: CGFloat { radius * 2 }
    let animationDuration: Double
    let numberOfPoints: Int
    let colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    var pointSize: CGFloat { radius * 0.2 }
    let pointScaleRatio: CGFloat
    @State private var rotateAngle: Double = 0
    @State private var pointScale: CGFloat = 1.0
    @State private var timer: AnyCancellable?
    @State private var cancellables: [AnyCancellable] = []
    let addOppositeAnimation: Bool
    let shadowRadius: CGFloat
    let shadowOffset: CGFloat
    let shadowOpacity: CGFloat
    var backgroundCornerRadius: CGFloat { frameSize / 10 }
    let backgroundOpacity: CGFloat
    let addBackground: Bool
    
    init(objectShape: T = Circle(),
         frameSize: CGFloat = 300,
         animationDuration: Double = 2.0,
         numberOfPoints: Int = 5,
         pointScaleRatio: CGFloat = 1.0,
         addOppositeAnimation: Bool = true,
         shadowRadius: CGFloat = 20,
         shadowOffset: CGFloat = 20,
         shadowOpacity: CGFloat = 0.5,
         backgroundOpacity: CGFloat = 0.3,
         addBackground: Bool = true
    ) {
        self.objectShape = objectShape
        self.frameSize = frameSize
        self.animationDuration = animationDuration
        self.numberOfPoints = numberOfPoints
        self.pointScaleRatio = pointScaleRatio
        self.addOppositeAnimation = addOppositeAnimation
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.shadowOpacity = shadowOpacity
        self.backgroundOpacity = backgroundOpacity
        self.addBackground = addBackground
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
                .offset(y: -shadowOffset(shadowOffset, isOpposite: false))
                
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
                    .offset(y: shadowOffset(shadowOffset, isOpposite: true))
                }
            }
            .frame(width: size, height: size)
            .onAppear {
                let animationSteps: CGFloat = 36
                Timer.publish(every: animationDuration / animationSteps, on: .main, in: .default)
                    .autoconnect()
                    .eraseToAnyPublisher()
                    .sink { _ in
                        withAnimation(.linear) {
                            rotateAngle += (360.0 / animationSteps)
                            
                            let baseScale = 1.0
                            let scaleOffset = rotateAngle < 180
                            ? CGFloat(rotateAngle) / 180
                            : CGFloat(360 - rotateAngle) / 180
                            pointScale = pointScaleRatio * (baseScale + scaleOffset)
                        }
                        
                        if rotateAngle >= 360 {
                            rotateAngle = 0
                        }
                    }
                    .store(in: &cancellables)
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
    
    private func shadowRadius(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let scale = pointScale / pointScaleRatio
        let shadowRadiusRatio = isOpposite
        ? 1.0 - (scale - 1.0)
        : scale - 1.0
        return value * shadowRadiusRatio
    }
    
    private func shadowOffset(_ value: CGFloat, isOpposite: Bool) -> CGFloat {
        let scale = pointScale / pointScaleRatio
        let shadowOffsetRatio = isOpposite
        ? -(1.0 - (scale - 1.0))
        : scale - 1.0
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

struct PreviewView10: View {
    enum ShapeType: CaseIterable {
        case circle, rectangle
    }
    @State private var colorScheme: ColorScheme = .light
    @State private var objectShape: ShapeType = .circle
    @State private var frameSize: CGFloat = 300
    @State private var animationDuration: CGFloat = 2.0
    @State private var numberOfPoints: Int = 5
    @State private var addOppositeAnimation: Bool = true
    @State private var backgroundOpacity: CGFloat = 0.3
    @State private var shadowRadius: CGFloat = 20
    @State private var shadowOffset: CGFloat = 20
    @State private var addBackground: Bool = false
    private let maxFrameHeight: CGFloat = 350
    
    var body: some View {
        VStack {
            ZStack {
                switch objectShape {
                case .circle:
                    Step8_1(objectShape: Circle(),
                            frameSize: frameSize,
                            animationDuration: animationDuration,
                            numberOfPoints: numberOfPoints,
                            addOppositeAnimation: addOppositeAnimation,
                            shadowRadius: shadowRadius,
                            shadowOffset: shadowOffset,
                            backgroundOpacity: backgroundOpacity,
                            addBackground: addBackground)
                case .rectangle:
                    Step8_1(objectShape: Rectangle(),
                            frameSize: frameSize,
                            animationDuration: animationDuration,
                            numberOfPoints: numberOfPoints,
                            addOppositeAnimation: addOppositeAnimation,
                            shadowRadius: shadowRadius,
                            shadowOffset: shadowOffset,
                            backgroundOpacity: backgroundOpacity,
                            addBackground: addBackground)
                }
            }
            .id(UUID())
            .frame(height: maxFrameHeight)
            
            VStack {
                SegmentedPickerRow(title: "colorScheme", selection: $colorScheme, selectionList: ColorScheme.allCases)
                
                SegmentedPickerRow(title: "objectShape", selection: $objectShape, selectionList: ShapeType.allCases)
                
                ToggleRow(title: "addOppositeAnimation", isOn: $addOppositeAnimation)
                
                ToggleRow(title: "addBackground", isOn: $addBackground)
                
                SliderRow(title: "frameSize", value: $frameSize, in: 50...maxFrameHeight, step: 1)
                
                SliderRow(title: "animationDuration", value: $animationDuration, in: 0...10, step: 0.1)
                
                SliderRow(title: "backgroundOpacity", value: $backgroundOpacity, in: 0...1, step: 0.1)
                
                SliderRow(title: "shadowRadius", value: $shadowRadius, in: 0...30, step: 0.5)
                
                SliderRow(title: "shadowOffset", value: $shadowOffset, in: 0...30, step: 0.5)
                
                StepperRow(title: "numberOfPoints", value: $numberOfPoints, in: 1...10)
            }
            .padding(.horizontal, 20)
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .preferredColorScheme(colorScheme)
    }
    
    func ToggleRow(title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Toggle(isOn: isOn) {}
        }
    }
    
    func SliderRow(title: String, value: Binding<CGFloat>, in range: ClosedRange<CGFloat>, step: CGFloat = 1) -> some View {
        HStack {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(describing: value.wrappedValue))
                    .bold()
            }
            
            Slider(value: value,
                   in: Double(range.lowerBound)...Double(range.upperBound),
                   step: Double(step))
            .padding(.horizontal)
        }
    }
    
    func StepperRow(title: String, value: Binding<Int>, in range: ClosedRange<Int>, step: Int = 1) -> some View {
        HStack {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(describing: value.wrappedValue))
                    .bold()
            }
            
            Stepper("", value: value,
                    in: range.lowerBound...range.upperBound,
                    step: step)
            .padding(.horizontal)
        }
    }
    
    func SegmentedPickerRow<T: Hashable>(title: String, selection: Binding<T>, selectionList: [T]) -> some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Picker("", selection: selection) {
                ForEach(selectionList, id: \.self) { row in
                    Text("\(String(describing: row))")
                        .tag(row)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct PreviewView11: View {
    enum ShapeType: CaseIterable {
        case circle, rectangle
    }
    @State private var colorScheme: ColorScheme = .light
    @State private var objectShape: ShapeType = .circle
    @State private var frameSize: CGFloat = 300
    @State private var animationDuration: CGFloat = 2.0
    @State private var numberOfPoints: Int = 5
    @State private var addOppositeAnimation: Bool = true
    @State private var backgroundOpacity: CGFloat = 0.3
    @State private var shadowRadius: CGFloat = 20
    @State private var shadowOffset: CGFloat = 20
    @State private var shadowOpacity: CGFloat = 0.5
    @State private var addBackground: Bool = false
    @State private var pointScaleRatio: CGFloat = 1.0
    
    private let maxFrameHeight: CGFloat = 350
    private let rowTextWidth: CGFloat = 200
    
    var body: some View {
        VStack {
            ZStack {
                switch objectShape {
                case .circle:
                    Step8_3(objectShape: Circle(),
                            frameSize: frameSize,
                            animationDuration: animationDuration,
                            numberOfPoints: numberOfPoints,
                            pointScaleRatio: pointScaleRatio,
                            addOppositeAnimation: addOppositeAnimation,
                            shadowRadius: shadowRadius,
                            shadowOffset: shadowOffset,
                            shadowOpacity: shadowOpacity,
                            backgroundOpacity: backgroundOpacity,
                            addBackground: addBackground)
                case .rectangle:
                    Step8_3(objectShape: Rectangle(),
                            frameSize: frameSize,
                            animationDuration: animationDuration,
                            numberOfPoints: numberOfPoints,
                            pointScaleRatio: pointScaleRatio,
                            addOppositeAnimation: addOppositeAnimation,
                            shadowRadius: shadowRadius,
                            shadowOffset: shadowOffset,
                            shadowOpacity: shadowOpacity,
                            backgroundOpacity: backgroundOpacity,
                            addBackground: addBackground)
                }
            }
            .id(UUID())
            .frame(height: maxFrameHeight)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    SegmentedPickerRow(title: "colorScheme", selection: $colorScheme, selectionList: ColorScheme.allCases)
                    
                    Divider()
                    
                    SegmentedPickerRow(title: "objectShape", selection: $objectShape, selectionList: ShapeType.allCases)
                    
                    Divider()
                    
                    ToggleRow(title: "addOppositeAnimation", isOn: $addOppositeAnimation)
                    
                    Divider()
                    
                    ToggleRow(title: "addBackground", isOn: $addBackground)
                    
                    Divider()
                    
                    VStack {
                        SliderRow(title: "frameSize", value: $frameSize, in: 50...maxFrameHeight, step: 1)
                        
                        Divider()
                        
                        SliderRow(title: "animationDuration", value: $animationDuration, in: 0...10, step: 0.1)
                        
                        Divider()
                        
                        SliderRow(title: "backgroundOpacity", value: $backgroundOpacity, in: 0...1, step: 0.1)
                        
                        Divider()
                        
                        SliderRow(title: "pointScaleRatio", value: $pointScaleRatio, in: 0...3, step: 0.1)
                        
                        Divider()
                        
                        SliderRow(title: "shadowRadius", value: $shadowRadius, in: 0...30, step: 0.5)
                        
                        Divider()
                        
                        SliderRow(title: "shadowOffset", value: $shadowOffset, in: 0...30, step: 0.5)
                        
                        Divider()
                        
                        SliderRow(title: "shadowOpacity", value: $shadowOpacity, in: 0...1, step: 0.1)
                        
                        Divider()
                    }
                    
                    StepperRow(title: "numberOfPoints", value: $numberOfPoints, in: 1...10)
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .preferredColorScheme(colorScheme)
    }
    
    func ToggleRow(title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Toggle(isOn: isOn) {}
        }
    }
    
    func SliderRow(title: String, value: Binding<CGFloat>, in range: ClosedRange<CGFloat>, step: CGFloat = 1) -> some View {
        HStack {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(describing: value.wrappedValue))
                    .bold()
            }
            
            Slider(value: value,
                   in: Double(range.lowerBound)...Double(range.upperBound),
                   step: Double(step))
            .padding(.horizontal)
        }
    }
    
    func StepperRow(title: String, value: Binding<Int>, in range: ClosedRange<Int>, step: Int = 1) -> some View {
        HStack {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(describing: value.wrappedValue))
                    .bold()
            }
            
            Stepper("", value: value,
                    in: range.lowerBound...range.upperBound,
                    step: step)
            .padding(.horizontal)
        }
    }
    
    func SegmentedPickerRow<T: Hashable>(title: String, selection: Binding<T>, selectionList: [T]) -> some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Picker("", selection: selection) {
                ForEach(selectionList, id: \.self) { row in
                    Text("\(String(describing: row))")
                        .tag(row)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct PreviewView12: View {
    enum ShapeType: CaseIterable {
        case circle, rectangle
    }
    @State private var colorScheme: ColorScheme = .light
    @State private var objectShape: ShapeType = .circle
    @State private var frameSize: CGFloat = 300
    @State private var animationDuration: CGFloat = 2.0
    @State private var numberOfPoints: Int = 5
    @State private var addOppositeAnimation: Bool = true
    @State private var backgroundOpacity: CGFloat = 0.3
    @State private var shadowRadius: CGFloat = 20
    @State private var shadowOffset: CGFloat = 20
    @State private var shadowOpacity: CGFloat = 0.5
    @State private var addBackground: Bool = false
    @State private var pointScaleRatio: CGFloat = 1.0
    
    private let maxFrameHeight: CGFloat = 350
    private let rowTextWidth: CGFloat = 200
    
    var body: some View {
        VStack {
            ZStack {
                switch objectShape {
                case .circle:
                    Step8_3(objectShape: Circle(),
                            frameSize: frameSize,
                            animationDuration: animationDuration,
                            numberOfPoints: numberOfPoints,
                            pointScaleRatio: pointScaleRatio,
                            addOppositeAnimation: addOppositeAnimation,
                            shadowRadius: shadowRadius,
                            shadowOffset: shadowOffset,
                            shadowOpacity: shadowOpacity,
                            backgroundOpacity: backgroundOpacity,
                            addBackground: addBackground)
                case .rectangle:
                    Step8_3(objectShape: Rectangle(),
                            frameSize: frameSize,
                            animationDuration: animationDuration,
                            numberOfPoints: numberOfPoints,
                            pointScaleRatio: pointScaleRatio,
                            addOppositeAnimation: addOppositeAnimation,
                            shadowRadius: shadowRadius,
                            shadowOffset: shadowOffset,
                            shadowOpacity: shadowOpacity,
                            backgroundOpacity: backgroundOpacity,
                            addBackground: addBackground)
                }
            }
            .id(UUID())
            .frame(height: maxFrameHeight)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    SegmentedPickerRow(title: "colorScheme", selection: $colorScheme, selectionList: ColorScheme.allCases)
                    
                    Divider()
                    
                    SegmentedPickerRow(title: "objectShape", selection: $objectShape, selectionList: ShapeType.allCases)
                    
                    Divider()
                    
                    ToggleRow(title: "addOppositeAnimation", isOn: $addOppositeAnimation)
                    
                    Divider()
                    
                    ToggleRow(title: "addBackground", isOn: $addBackground)
                    
                    Divider()
                    
                    VStack {
                        SliderRow(title: "frameSize", value: $frameSize, in: 50...maxFrameHeight, step: 1)
                        
                        Divider()
                        
                        SliderRow(title: "animationDuration", value: $animationDuration, in: 0...10, step: 0.1)
                        
                        Divider()
                        
                        SliderRow(title: "backgroundOpacity", value: $backgroundOpacity, in: 0...1, step: 0.1)
                        
                        Divider()
                        
                        SliderRow(title: "pointScaleRatio", value: $pointScaleRatio, in: 0...3, step: 0.1)
                        
                        Divider()
                        
                        SliderRow(title: "shadowRadius", value: $shadowRadius, in: 0...30, step: 0.5)
                        
                        Divider()
                        
                        SliderRow(title: "shadowOffset", value: $shadowOffset, in: 0...30, step: 0.5)
                        
                        Divider()
                        
                        SliderRow(title: "shadowOpacity", value: $shadowOpacity, in: 0...1, step: 0.1)
                        
                        Divider()
                    }
                    
                    StepperRow(title: "numberOfPoints", value: $numberOfPoints, in: 1...10)
                }
                .padding(.vertical, 20)
            }
            .padding(.horizontal, 20)
            .background(Color.gray.opacity(0.2))
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .preferredColorScheme(colorScheme)
    }
    
    func ToggleRow(title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(width: rowTextWidth)
            
            Toggle(isOn: isOn) {}
        }
    }
    
    func SliderRow(title: String, value: Binding<CGFloat>, in range: ClosedRange<CGFloat>, step: CGFloat = 1) -> some View {
        HStack {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Text("\(value.wrappedValue, specifier: "%.1f")")
                    .bold()
            }
            .font(.callout)
            .frame(width: rowTextWidth)
            
            Slider(value: value,
                   in: Double(range.lowerBound)...Double(range.upperBound),
                   step: Double(step))
            .padding(.horizontal)
        }
    }
    
    func StepperRow(title: String, value: Binding<Int>, in range: ClosedRange<Int>, step: Int = 1) -> some View {
        HStack {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(describing: value.wrappedValue))
                    .bold()
            }
            .font(.callout)
            .frame(width: rowTextWidth)
            
            Stepper("", value: value,
                    in: range.lowerBound...range.upperBound,
                    step: step)
            .padding(.horizontal)
        }
    }
    
    func SegmentedPickerRow<T: Hashable>(title: String, selection: Binding<T>, selectionList: [T]) -> some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(width: rowTextWidth)
            
            Picker("", selection: selection) {
                ForEach(selectionList, id: \.self) { row in
                    Text("\(String(describing: row))")
                        .tag(row)
                }
            }
            .font(.callout)
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

