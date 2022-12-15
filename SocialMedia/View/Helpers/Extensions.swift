//
//  Extensions.swift
//  SocialMedia
//
//  Created by Evgeny on 15.12.22.
//

import SwiftUI

extension View {
    
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    func closeKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func hAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func border(_ width: CGFloat, _ color: Color) -> some View {
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background {
                Capsule(style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    
    func fillView(_ color: Color) -> some View {
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background {
                Capsule(style: .continuous)
                    .fill(color)
            }
    }
}
