//
//  LoadingViewSimulator.swift
//  LoadingViewSample1
//
//  Created by YomEngine on 2023/12/29.
//

import SwiftUI

enum ShapeType: String, CaseIterable {
    case circle = "Circle",
         rectangle = "Rectangle",
         squircle = "Squircle"
}

extension ColorScheme: CaseIterable {
    var value: String {
        switch self {
        case .dark:
            return "dark"
        case .light:
            return "light"
        @unknown default:
            return "unknown"
        }
    }
}

struct LoadingViewSimulator: View {
    private let sliderWidth: CGFloat = 120
    @State private var animationDuration: CGFloat = 2.0
    @State private var selectedColorScheme: ColorScheme = .light
    @State private var selectedShape: ShapeType = .circle
    @State private var frameSize: CGFloat = 300
    @State private var numberOfPoints: Int = 5
    @State private var pointScale: CGFloat = 1.0
    @State private var addOppositeAnimation: Bool = true
    @State private var addBackground: Bool = false
    @State private var backgroundOpacity: CGFloat = 0.3
    @State private var shadowOpacity: CGFloat = 0.5
    @State private var shadowRadius: CGFloat = 20
    @State private var shadowOffset: CGFloat = 20
    
    var body: some View {
        VStack {
            
            switch selectedShape {
            case .circle:
                LoadingView(objectShape: Circle(), frameSize: frameSize,
                            animationDuration: animationDuration,
                            numberOfPoints: Int(numberOfPoints),
                            pointScale: pointScale,
                            addOppositeAnimation: addOppositeAnimation,
                            addBackground: addBackground,
                            backgroundOpacity: backgroundOpacity.native,
                            shadowOpacity: shadowOpacity,
                            shadowRadius: shadowRadius,
                            shadowOffset: shadowOffset
                )
                .id(UUID())
                .frame(maxHeight: .infinity)
                
            case .rectangle:
                LoadingView(objectShape: Rectangle(), frameSize: frameSize,
                            animationDuration: animationDuration,
                            numberOfPoints: Int(numberOfPoints),
                            pointScale: pointScale,
                            addOppositeAnimation: addOppositeAnimation,
                            addBackground: addBackground,
                            backgroundOpacity: backgroundOpacity.native,
                            shadowOpacity: shadowOpacity,
                            shadowRadius: shadowRadius,
                            shadowOffset: shadowOffset
                )
                .id(UUID())
                .frame(maxHeight: .infinity)
                
            case .squircle:
                LoadingView(objectShape: Squircle(), frameSize: frameSize,
                            animationDuration: animationDuration,
                            numberOfPoints: Int(numberOfPoints),
                            pointScale: pointScale,
                            addOppositeAnimation: addOppositeAnimation,
                            addBackground: addBackground,
                            backgroundOpacity: backgroundOpacity.native,
                            shadowOpacity: shadowOpacity,
                            shadowRadius: shadowRadius,
                            shadowOffset: shadowOffset
                )
                .id(UUID())
                .frame(maxHeight: .infinity)
            }
            
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Text("colorScheme")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Picker("", selection: $selectedColorScheme) {
                            ForEach(ColorScheme.allCases, id: \.self) { sheme in
                                Text(sheme.value)
                            }
                        }
                        .frame(width: sliderWidth, alignment: .trailing)
                    }
                    .padding(.horizontal, 10)
                    
                    Divider()
                    
                    HStack {
                        Text("objectShape")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Picker("", selection: $selectedShape) {
                            ForEach(ShapeType.allCases, id: \.self) { type in
                                Text(type.rawValue)
                            }
                        }
                        .frame(width: sliderWidth, alignment: .trailing)
                    }
                    .padding(.horizontal, 10)
                    
                    Divider()

                    HStack {
                        HStack {
                            Text("animationDuration:")
                            Text("\(animationDuration, specifier: "%.1f")").fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Slider(value: $animationDuration, in: 0...5, step: 0.1)
                            .frame(width: sliderWidth, alignment: .trailing)
                    }
                    .padding(.horizontal, 10)
                    
                    Divider()
                    
                    HStack {
                        HStack {
                            Text("frameSize:")
                            Text("\(frameSize, specifier: "%.0f")").fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Slider(value: $frameSize, in: 100...400, step: 0.5)
                            .frame(width: sliderWidth, alignment: .trailing)

                    }
                    .padding(.horizontal, 10)
                    
                    Divider()
                    
                    HStack {
                        HStack {
                        Text("numberOfPoints:")
                        Text("\(numberOfPoints)").fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Stepper(value: $numberOfPoints, in: 0...10, step: 1) {
                        }
                        .frame(width: sliderWidth, alignment: .trailing)
                    }
                    .padding(.horizontal, 10)
                    
                    Divider()
                }
                .padding(.horizontal, 20)
                

                VStack {
                    HStack {
                        HStack {
                            Text("pointScale:")
                            Text("\(pointScale, specifier: "%.1f")").fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Slider(value: $pointScale, in: 0...3, step: 0.1)
                            .frame(width: sliderWidth, alignment: .trailing)
                    }
                    .padding(.horizontal, 10)
                    
                    Divider()
                    
                    HStack {
                        HStack {
                        Text("addOppositeAnimation:")
                        Text("\(addOppositeAnimation ? "true" : "false")").fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Toggle(isOn: $addOppositeAnimation) {
                            
                        }
                        .frame(width: sliderWidth, alignment: .trailing)
                    }
                    .padding(.horizontal, 10)

                    Divider()
                    

                }
                .padding(.horizontal, 20)
                
                VStack {
                    HStack {
                        HStack {
                        Text("addBackground:")
                        Text("\(addBackground ? "true" : "false")").fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Toggle(isOn: $addBackground) {
                            
                        }
                        .frame(width: sliderWidth, alignment: .trailing)
                    }
                    .padding(.horizontal, 10)
                    
                    Divider()
                    
                    HStack {
                        HStack {
                        Text("backgroundOpacity:")
                        Text("\(backgroundOpacity, specifier: "%.1f")").fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Slider(value: $backgroundOpacity, in: 0...1, step: 0.1)
                            .frame(width: sliderWidth, alignment: .trailing)
                    }
                    .padding(.horizontal, 10)
                    
                    Divider()
                    
                    HStack {
                        HStack {
                            Text("shadowOpacity:")
                            Text("\(shadowOpacity, specifier: "%.1f")").fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Slider(value: $shadowOpacity, in: 0...1, step: 0.1)
                            .frame(width: sliderWidth, alignment: .trailing)
                    }
                    .padding(.horizontal, 10)
                    
                    Divider()
                    
                    HStack {
                        HStack {
                            Text("shadowRadius:")
                            Text("\(shadowRadius, specifier: "%.1f")").fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Slider(value: $shadowRadius, in: 0...50, step: 0.5)
                            .frame(width: sliderWidth, alignment: .trailing)
                    }
                    .padding(.horizontal, 10)
                    
                    Divider()
                    
                    HStack {
                        HStack {
                        Text("shadowOffset:")
                        Text("\(shadowOffset, specifier: "%.1f")").fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Slider(value: $shadowOffset, in: 0...50, step: 0.5)
                            .frame(width: sliderWidth, alignment: .trailing)
                    }
                    .padding(.horizontal, 10)

                    Divider()
                }
                .padding(.horizontal, 20)

            }
            .frame(maxHeight: .infinity)
        }
        .preferredColorScheme(selectedColorScheme)
    }
}

struct LoadingViewSampleView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingViewSimulator()
    }
}



