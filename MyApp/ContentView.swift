//
//  ContentView.swift
//  MyApp
//
//  Created by Jinwoo Kim on 11/25/24.
//

import SwiftUI

@_expose(Cxx)
public nonisolated func makeContentHostingController() -> UIViewController {
    MainActor.assumeIsolated {
        UIHostingController(rootView: ContentView())
    }
}

struct ContentView: View {
    @State private var sliderValue: Float = 50.0
    @State private var stepperValue: Double = 50.0
    @State private var isOn: Bool = true
    
    var body: some View {
        VStack {
            TVSlider.SwiftUIView(value: $sliderValue, in: 0.0...100.0) { isEditing in
                print(isEditing)
            }
//            .continuous(false)
            .onChange(of: sliderValue) { oldValue, newValue in
                print(newValue)
            }
            
            TVStepper.SwiftUIView(value: $stepperValue, in: 0.0...100.0, step: 10.0) { isEditing in
                print(isEditing)
            }
            .continuous(true)
            .autorepeat(true)
            .wraps(true)
            .onChange(of: stepperValue) { oldValue, newValue in
                print(newValue)
            }
            
            TVSwitch.SwiftUIView(isOn: $isOn)
                .tint(Color.orange)
                .onChange(of: isOn) { oldValue, newValue in
                    print(newValue)
                }
        }
    }
}

#Preview {
    ContentView()
}
