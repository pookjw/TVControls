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
            
            stepper.addAction(.init(handler: { [value] action in
                let stepper = action.sender as! TVStepper
                
                if value.wrappedValue != stepper.value {
                    value.wrappedValue = stepper.value
                }
            }))
            
            context.coordinator.isEditingObservation?.invalidate()
            context.coordinator.isEditingObservation = stepper.observe(\.isEditing, options: .new) { [onEditingChanged] stepper, change in
                MainActor.assumeIsolated {
                    onEditingChanged(change.newValue ?? stepper.isEditing)
                }
            }
            
            return stepper
        }
        
        func updateUIView(_ stepper: TVStepper, context: Context) {
            stepper.minimumValue = bounds.lowerBound
            stepper.maximumValue = bounds.upperBound
            stepper.value = value.wrappedValue
            stepper.stepValue = step
            stepper.isContinuous = isContinuous
            stepper.autorepeat = autorepeat
            stepper.wraps = wraps
            stepper.isEnabled = context.environment.isEnabled
            
            for action in stepper.actions {
                stepper.removeAction(action)
            }
            
            stepper.addAction(.init(handler: { [value] action in
                let stepper = action.sender as! TVStepper
                
                if value.wrappedValue != stepper.value {
                    value.wrappedValue = stepper.value
                }
            }))
            
            context.coordinator.isEditingObservation?.invalidate()
            context.coordinator.isEditingObservation = stepper.observe(\.isEditing, options: .new) { [onEditingChanged] stepper, change in
                MainActor.assumeIsolated {
                    onEditingChanged(change.newValue ?? stepper.isEditing)
                }
            }
        }
        
        func makeCoordinator() -> Coordinator {
            .init()
        }
        
        func continuous(_ continuous: Bool) -> Self {
            var copy = self
            copy.isContinuous = continuous
            return copy
        }
        
        func autorepeat(_ autorepeat: Bool) -> Self {
            var copy = self
            copy.autorepeat = autorepeat
            return copy
        }
        
        func wraps(_ wraps: Bool) -> Self {
            var copy = self
            copy.wraps = wraps
            return copy
        }
        
        final class Coordinator {
            @MainActor fileprivate var isEditingObservation: NSKeyValueObservation?
            
            deinit {
                isEditingObservation?.invalidate()
            }
        }
    }
}
