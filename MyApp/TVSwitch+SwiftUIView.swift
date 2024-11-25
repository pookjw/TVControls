//
//  TVSwitch+SwiftUIView.swift
//  MyApp
//
//  Created by Jinwoo Kim on 11/25/24.
//

import SwiftUI

extension TVSwitch {
    struct SwiftUIView: UIViewRepresentable {
        private static let identifier: UIAction.Identifier = .init("TVSwitch.SwiftUIView")
        
        private let isOn: Binding<Bool>
        
        init(isOn: Binding<Bool>) {
            self.isOn = isOn
        }
        
        func makeUIView(context: Context) -> TVSwitch {
            let uiView = TVSwitch()
            
            uiView.isOn = isOn.wrappedValue
            uiView.isEnabled = context.environment.isEnabled
            
            uiView.addAction(
                .init(identifier: Self.identifier, handler: { [isOn] action in
                    let sender = action.sender as! TVSwitch
                    
                    if isOn.wrappedValue != sender.isOn {
                        isOn.wrappedValue = sender.isOn
                    }
                }
                     ),
                for: .valueChanged
            )
            
            return uiView
        }
        
        func updateUIView(_ uiView: TVSwitch, context: Context) {
            uiView.isOn = isOn.wrappedValue
            uiView.isEnabled = context.environment.isEnabled
            
            uiView.removeAction(identifiedBy:Self.identifier, for: .valueChanged)
            
            uiView.addAction(
                .init(identifier: Self.identifier, handler: { [isOn] action in
                    let sender = unsafeBitCast(action.sender! as AnyObject, to: TVSwitch.self)
                    
                    if isOn.wrappedValue != sender.isOn {
                        isOn.wrappedValue = sender.isOn
                    }
                }
                     ),
                for: .valueChanged
            )
        }
    }
}
