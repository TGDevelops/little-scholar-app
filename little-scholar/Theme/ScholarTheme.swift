//
//  ScholarTheme.swift
//  little-scholar
//

import SwiftUI
import UIKit

enum ScholarTheme {
    static let surface = Color(uiColor: .secondarySystemGroupedBackground)
    static let elevatedSurface = Color(uiColor: .tertiarySystemGroupedBackground)
    static let controlSurface = Color(uiColor: .systemBackground)
    static let shadow = Color(uiColor: .black).opacity(0.10)
}

enum KidScholarTheme {
    static let accent = Color.mint
    static let secondaryAccent = Color.pink
    static let profileSurface = Color(uiColor: .systemBackground).opacity(0.94)
    static let selectedProfileSurface = Color.mint.opacity(0.28)
    static let cardSurface = Color(uiColor: .secondarySystemGroupedBackground).opacity(0.96)
    static let actionSurface = Color.yellow.opacity(0.22)
}

struct LittleScholarBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    private var gradientColors: [Color] {
        if colorScheme == .dark {
            return [
                Color.indigo.opacity(0.30),
                Color.teal.opacity(0.18),
                Color.purple.opacity(0.24)
            ]
        }
        return [
            Color.yellow.opacity(0.28),
            Color.cyan.opacity(0.22),
            Color.pink.opacity(0.18)
        ]
    }

    var body: some View {
        LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
            .background(Color(uiColor: .systemGroupedBackground))
            .ignoresSafeArea()
    }
}

struct KidScholarBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    private var gradientColors: [Color] {
        if colorScheme == .dark {
            return [
                Color.mint.opacity(0.20),
                Color.purple.opacity(0.24),
                Color.orange.opacity(0.14)
            ]
        }
        return [
            Color.mint.opacity(0.34),
            Color.yellow.opacity(0.26),
            Color.pink.opacity(0.22)
        ]
    }

    var body: some View {
        LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
            .background(Color(uiColor: .systemGroupedBackground))
            .ignoresSafeArea()
    }
}

struct CheerfulButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        CheerfulButton(label: configuration.label, color: color, isPressed: configuration.isPressed)
    }

    private struct CheerfulButton<Label: View>: View {
        @Environment(\.isEnabled) private var isEnabled

        let label: Label
        let color: Color
        let isPressed: Bool

        var body: some View {
            label
                .font(.title3.bold())
                .foregroundStyle(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 18)
                .background(isEnabled ? color.opacity(isPressed ? 0.72 : 1) : Color.gray.opacity(0.45))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .scaleEffect(isPressed && isEnabled ? 0.97 : 1)
                .opacity(isEnabled ? 1 : 0.62)
        }
    }
}

@ViewBuilder
func sectionCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
    themedSectionCard(title: title, icon: icon, surface: ScholarTheme.surface, accent: .primary, content: content)
}

@ViewBuilder
func kidSectionCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
    themedSectionCard(title: title, icon: icon, surface: KidScholarTheme.cardSurface, accent: KidScholarTheme.accent, content: content)
}

@ViewBuilder
private func themedSectionCard<Content: View>(title: String, icon: String, surface: Color, accent: Color, @ViewBuilder content: () -> Content) -> some View {
    VStack(alignment: .leading, spacing: 16) {
        Label(title, systemImage: icon)
            .font(.title2.bold())
            .foregroundStyle(accent)
        content()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(20)
    .background(surface)
    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    .shadow(color: ScholarTheme.shadow, radius: 12, y: 6)
}

func row(icon: String, title: String, subtitle: String, color: Color) -> some View {
    HStack(spacing: 12) {
        Image(systemName: icon)
            .font(.title)
            .foregroundStyle(color)
            .frame(width: 42)
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
            Text(subtitle)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
        }
        Spacer()
    }
    .padding()
    .background(ScholarTheme.controlSurface)
    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
}
