//
//  GlassCard.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import SwiftUI

/// Presents content on a rounded Liquid Glass card.
///
/// Replaces the hand-rolled `.ultraThinMaterial` card that was duplicated across the detail screen
/// with the system Liquid Glass material introduced in iOS 27.
private struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content.glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
    }
}

extension View {
    /// Wraps the view in a rounded Liquid Glass card.
    func glassCard(cornerRadius: CGFloat = 15) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius))
    }
}
