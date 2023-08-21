//
//  CategorySelectionView.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 18/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct CategorySelectionView: View {
    @Binding var selected: Int
    var items: [String]
    
    private func textColor(for index: Int) -> Color {
        index == selected ? .systemBackground : .systemGray
    }
    
    private func bgColor(for index: Int) -> Color {
        index == selected ? .primary : .systemGray5
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(Array(items.enumerated()), id: \.offset) { item in
                    Text(item.element)
                        .foregroundColor(textColor(for: item.offset))
                        .font(.avenirNextMedium(size: 17))
                        .padding(.horizontal, 10)
                        .frame(height: 32)
                        .background(bgColor(for: item.offset), in: Capsule())
                        .onTapGesture {
                            withAnimation { selected = item.offset }
                        }
                }
            }
            .padding(.horizontal, 20)
        }
        .scrollIndicators(.never)
    }
}

struct CategorySelectionView_Previews: PreviewProvider {
    @State static var selection = 0
    
    static var previews: some View {
        CategorySelectionView(selected: $selection, items: ["All", "Teaser", "Trailer", "Behind the Scenes", "Clips", "Bloopers", "Featurettes"])
            .previewLayout(.fixed(width: 400, height: 50))
    }
}
