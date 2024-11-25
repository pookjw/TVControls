//
//  TVStepper+SwiftUIView.swift
//  MyApp
//
//  Created by Jinwoo Kim on 11/25/24.
//

import SwiftUI

extension TVStepper {
    struct SwiftUIView: UIViewRepresentable {
        private let value: Binding<Double>
        private let bounds: ClosedRange<Double>
        private let step: Double.Stride
        private let onEditingChanged: @Sendable (Bool) -> Void
        private var isContinuous: Bool
        private var autorepeat: Bool
        private var wraps: Bool
        
        nonisolated
        init<F>(
            value: Binding<F>,
            in bounds: ClosedRange<F>,
            step: F.Stride = 1,
            onEditingChanged: @Sendable @escaping (Bool) -> Void = { _ in }
        ) where F : BinaryFloatingPoint & Sendable, F.Stride : BinaryFloatingPoint {
            self.value = .init(
                get: { 
                    return Double(value.wrappedValue)
                },
                set: { newValue in
                    if value.wrappedValue != F(newValue) {
                        value.wrappedValue = F(newValue)
                    }
                }
            )
            
            self.bounds = .init(uncheckedBounds: (Double(bounds.lowerBound), Double(bounds.upperBound)))
            self.step = Double.Stride(step)
            self.onEditingChanged = onEditingChanged
            self.isContinuous = true
            self.autorepeat = true
            self.wraps = false
        }
        
        func makeUIView(context: Context) -> TVStepper {
            let stepper = TVStepper()
            stepper.minimumValue = bounds.lowerBound
            stepper.maximumValue = bounds.upperBound
            stepper.value = value.wrappedValue
            stepper.stepValue = step
            stepper.isContinuous = isContinuous
            stepper.autorepeat = autorepeat
            stepper.wraps = wraps
            stepper.isEnabled = context.environment.isEnabled
            
            
            
            return stepper
        }
        
        func updateUIView(_ uiView: TVStepper, context: Context) {
            
        }
        
        func makeCoordinator() -> Coordinator {
            .init()
        }
        
        final class Coordinator {
            @MainActor fileprivate var isEditingObservation: NSKeyValueObservation?
        }
    }
}
