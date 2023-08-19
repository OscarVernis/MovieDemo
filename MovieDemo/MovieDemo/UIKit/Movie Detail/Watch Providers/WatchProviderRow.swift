//
//  WatchProviderRow.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct WatchProviderRow: View {
    let title: String
    let description: String
    let url: URL?
    
    var body: some View {
        HStack(spacing: 10) {
            RemoteImage(url: url, placeholder: {
                Image(asset: .tv)
            })
            .foregroundColor(.systemGray2)
            .frame(width: 50, height: 50)
            .background(Color(asset: .SectionBackgroundColor))
            .cornerRadius(12)
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.avenirNextMedium(size: 16))
                if !description.isEmpty {
                    Text(description)
                        .foregroundColor(.secondary)
                        .font(.avenirNextDemiBold(size: 13))
                }
            }
            Spacer()
        }
        .listRowBackground(Color.clear)
    }
    
    init(title: String, description: String = "", url: URL? = nil) {
        self.title = title
        self.description = description
        self.url = url
    }
    
}

struct WatchProviderRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WatchProviderRow(title: "Apple TV", description: "STREAM, BUY, RENT", url: nil)
            WatchProviderRow(title: "Apple TV", url: nil)
        }
        .padding(.leading, 20)
    }
}
