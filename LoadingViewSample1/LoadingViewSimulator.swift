//
//  LoadingViewSimulator.swift
//  LoadingViewSample1
//
//  Created by YomEngine on 2023/12/29.
//

import SwiftUI

struct LoadingViewSimulator: View {
    enum ShapeType: String, CaseIterable {
        case circle = "Circle",
             rectangle = "Rectangle",
             squircle = "Squircle"
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
                case .squircle:
                    Step8_3(objectShape: Squircle(),
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

#Preview {
    LoadingViewSimulator()
}
