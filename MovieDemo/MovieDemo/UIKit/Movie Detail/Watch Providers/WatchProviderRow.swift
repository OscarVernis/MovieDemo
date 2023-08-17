//
//  WatchProviderRow.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct WatchProviderRow: View {
    let providerName: String
    let url: URL?
    
    var body: some View {
        HStack() {
            RemoteImage(url: url, placeholder: {
                Image(systemName: "tv")
            })
            .foregroundColor(Color(uiColor: .systemGray2))
            .frame(width: 45, height: 45)
            .background(Color(asset: .SectionBackgroundColor))
            .cornerRadius(12)
            Text(providerName)
                .font(.avenirNextMedium(size: 16))
            Spacer()
        }
        .listRowBackground(Color.clear)
    }
}

struct WatchProviderRow_Previews: PreviewProvider {
    static var previews: some View {
        WatchProviderRow(providerName: "Apple TV", url: nil)
    }
}
