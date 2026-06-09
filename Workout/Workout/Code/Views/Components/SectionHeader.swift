//
//  SectionHeader.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import SwiftUI

/// A small, all-caps section header with a leading SF Symbol, used above the detail screen sections.
struct SectionHeader: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: systemImage)
            Text(title.uppercased())
        }
        .font(.subheadline)
        .foregroundStyle(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Previews
#Preview {
    SectionHeader(title: "Performance Over Time", systemImage: "clock")
        .padding()
}
