//
//  PosterRow.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 30/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct PosterRow<Model: Hashable>: View {
    let models: [Model]
    var tapAction: ((Model) -> Void)?
    var emptyMessage: NSAttributedString?
    var makePosterItemModel: (Model) -> PosterItemModel
    
    var body: some View {
        if let emptyMessage = emptyMessage, models.isEmpty {
            empty(emptyMessage)
        } else {
            itemRow()
        }
    }

    fileprivate func itemRow() -> some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 20) {
                ForEach(models, id:\.self) { model in
                    PosterItem(model: makePosterItemModel(model))
                        .frame(width: 140)
                        .onTapGesture {
                            tapAction?(model)
                        }
                }
            }
            .padding([.leading, .trailing], 20)
        }
    }
    
    func itemModel(for model: Model) {
        
    }
    
    fileprivate func empty(_ emptyMessage: NSAttributedString) -> some View {
        return VStack(spacing: 20) {
            Image(systemName: "film")
                .foregroundColor(Color(uiColor: .secondarySystemFill))
                .font(.system(size: 145))
            Text(AttributedString(emptyMessage))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundColor(Color(uiColor: .placeholderText))
                .font(.custom("Avenir Next Regular", size: 17))
        }
        .frame(height: 260)
    }
    
}

extension PosterRow where Model == MovieViewModel {
    init(movies: [MovieViewModel],
         showRating: Bool = false,
         tapAction: ((MovieViewModel) -> Void)? = nil,
         emptyMessage: NSAttributedString? = nil) {
        self.models = movies
        self.tapAction = tapAction
        self.emptyMessage = emptyMessage
        self.makePosterItemModel = { movie in
            PosterItemModel(movie: movie, showRating: showRating)
        }
    }
}

extension PosterRow where Model == CastCreditViewModel {
    init(cast: [CastCreditViewModel], tapAction: ((CastCreditViewModel) -> Void)? = nil) {
        self.models = cast
        self.tapAction = tapAction
        self.makePosterItemModel = PosterItemModel.init(credit:)
    }
}

struct PosterRow_Previews: PreviewProvider {
    static let movies = JSONMovieLoader(filename: "now_playing").viewModels
    static let movie = JSONMovieDetailsLoader(filename: "movie").viewModel

    static var previews: some View {
        PosterRow(cast: movie.topCast)
            .previewLayout(.fixed(width: 375, height: 300))
            .preferredColorScheme(.dark)
        PosterRow(movies: movies,
                  showRating: true)
            .previewLayout(.fixed(width: 375, height: 300))
            .preferredColorScheme(.dark)
        PosterRow(movies: movies,
                  showRating: false)
            .previewLayout(.fixed(width: 375, height: 300))
            .preferredColorScheme(.dark)
        PosterRow(movies: [],
                       emptyMessage: AttributedStringAsset.emptyRatedMessage)
            .previewLayout(.fixed(width: 375, height: 300))
            .preferredColorScheme(.dark)
    }
}
