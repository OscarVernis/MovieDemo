//
//  MovieBannerItem.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct MovieBannerItem: View {
    let movie: MovieViewModel
    
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                RemoteImage(url: movie.backdropImageURL(size: .w780),
                            placeholder: Image(asset: .BackdropPlaceholder))
                .frame(width: 300, height: 170)
                .padding(.bottom, 5)
                HStack {
                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .titleStyle()
                            .lineLimit(1)
                        Text(movie.genres())
                            .subtitleStyle()
                            .lineLimit(1)
                    }
                    Spacer()
                    Rating(progress: movie.percentRating)
                        .frame(width: 25, height: 25)
                }
        }
    }
}

struct MovieBanner_Previews: PreviewProvider {    
    static var previews: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                    MovieBannerItem(movie: MockData.movieVM)
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                }
            }
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        }
    }
}
