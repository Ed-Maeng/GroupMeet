//
//  Binding+Extensions.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

// This helper extension allows us to convert an optional binding (like @State var user: User?)
// into a non-optional binding (Binding<User>) for views that require one.
// This is useful for passing an optional state to a view that needs to modify it.
extension Binding {
    func toBinding<T>() -> Binding<T> where Value == T? {
        return Binding<T>(
            get: { self.wrappedValue! },
            set: { self.wrappedValue = $0 }
        )
    }
}
