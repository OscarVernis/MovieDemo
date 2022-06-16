//
//  TextStyles.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.label)
            .font(.titleFont)
    }
}

struct SubtitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.secondaryLabel)
            .font(.subtitleFont)
    }
}

struct DescriptionStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.secondaryLabel)
            .font(.descriptionFont)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(TitleStyle())
    }
    
    func subtitleStyle() -> some View {
        modifier(SubtitleStyle())
    }
    
    func descriptionStyle() -> some View {
        modifier(DescriptionStyle())
    }
}
