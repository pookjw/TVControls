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
    @State private var value: Float = 50.0
    
    var body: some View {
        VStack {
            TVSlider.SwiftUIView(value: $value, in: 0.0...100.0) { finished in
                print(finished)
            }
            .continuous(false)
            .onChange(of: value) { oldValue, newValue in
                print(newValue)
            }
        }
    }
}

#Preview {
    ContentView()
}
