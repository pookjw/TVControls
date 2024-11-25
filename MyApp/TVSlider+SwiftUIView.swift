//
//  TVSlider+SwiftUIView.swift
//  MyApp
//
//  Created by Jinwoo Kim on 11/25/24.
//

import SwiftUI

extension TVSlider {
    struct SwiftUIView: UIViewRepresentable {
        private let value: Binding<Float>
        private let bounds: ClosedRange<Float>
        private let step: Float.Stride
        private let onEditingChanged: @Sendable (Bool) -> Void
        private var isContinuous: Bool
        
        nonisolated init<V>(
            value: Binding<V>,
            in bounds: ClosedRange<V>,
            step: V.Stride = 1,
            onEditingChanged: @Sendable @escaping (Bool) -> Void = { _ in }
        ) where V : BinaryFloatingPoint & Sendable, V.Stride : BinaryFloatingPoint {
            self.value = .init(
                get: { 
                    return Float(value.wrappedValue)
                },
                set: { newValue in
                    if value.wrappedValue != V(newValue) {
                        value.wrappedValue = V(newValue)
                    }
                }
            )
            
            self.bounds = .init(uncheckedBounds: (Float(bounds.lowerBound), Float(bounds.upperBound)))
            self.step = Float.Stride(step)
            self.onEditingChanged = onEditingChanged
            self.isContinuous = true
        }
        
        func makeUIView(context: Context) -> TVSlider {
            let slider = TVSlider()
            slider.minimumValue = bounds.lowerBound
            slider.maximumValue = bounds.upperBound
            slider.value = value.wrappedValue
            slider.stepValue = step
            slider.isContinuous = isContinuous
            slider.isEnabled = context.environment.isEnabled
            
            slider.addAction(.init(handler: { [value] action in
                let slider = action.sender as! TVSlider
                
                if value.wrappedValue != slider.value {
                    value.wrappedValue = slider.value
                }
            }))
            
            context.coordinator.isEditingObservation = slider.observe(\.isEditing, options: .new) { [onEditingChanged] slider, change in
                MainActor.assumeIsolated { 
                    onEditingChanged(change.newValue ?? slider.isEditing)
                }
            }
            
            return slider
        }
        
        func updateUIView(_ slider: TVSlider, context: Context) {
            slider.minimumValue = bounds.lowerBound
            slider.maximumValue = bounds.upperBound
            slider.value = value.wrappedValue
            slider.stepValue = step
            slider.isContinuous = isContinuous
            slider.isEnabled = context.environment.isEnabled
            
            for action in slider.actions {
                slider.removeAction(action)
            }
            
            slider.addAction(.init(handler: { [value] action in
                let slider = action.sender as! TVSlider
                
                if value.wrappedValue != slider.value {
                    value.wrappedValue = slider.value
                }
            }))
            
            context.coordinator.isEditingObservation?.invalidate()
            context.coordinator.isEditingObservation = slider.observe(\.isEditing, options: .new) { [onEditingChanged] slider, change in
                MainActor.assumeIsolated { 
                    onEditingChanged(change.newValue ?? slider.isEditing)
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
        
        final class Coordinator {
            @MainActor fileprivate var isEditingObservation: NSKeyValueObservation?
        }
    }
}
