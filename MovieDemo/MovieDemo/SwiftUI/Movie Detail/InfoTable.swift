//
//  InfoTable.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 29/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct InfoTable<Model: Hashable>: View {
    var models: [Model]
    let columns: [GridItem]
    var createInfoItemModel: (Model) -> InfoItemModel
    var tapAction: ((Model) -> Void)?

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(models, id: \.self) { model in
                    InfoItem(model: createInfoItemModel(model))
                        .onTapGesture {
                            tapAction?(model)
                        }
                }
            }
            .padding([.leading, .trailing], 20)
        }
    }
}

extension InfoTable where Model == CrewCreditViewModel {
    init(credits: [CrewCreditViewModel], columns: Int = 2, tapAction: ((CrewCreditViewModel) -> Void)? = nil) {
        self.models = credits
        self.columns = Array<GridItem>(repeating: GridItem(.flexible()), count: columns)
        self.createInfoItemModel = { credit in
            InfoItemModel(title: credit.name, subtitle: credit.job)
        }
        self.tapAction = tapAction
    }
}

extension InfoTable where Model == [String : String] {
    init(info: [[String : String]], columns: Int = 1) {
        self.models = info
        self.columns = Array<GridItem>(repeating: GridItem(.flexible()), count: columns)
        self.createInfoItemModel = { info in
            InfoItemModel(title: info.keys.first!, subtitle: info.values.first!)
        }
    }
}

struct InfoTable_Previews: PreviewProvider {
    static let movieLoader = JSONMovieDetailsLoader(filename: "movie")
    static let movieViewModel = MovieViewModel(movie: Movie(id: 0, title: ""),
                                               service: movieLoader)

    static var previews: some View {
        NavigationView {
            VStack(spacing: 0) {
                InfoTable(credits: movieViewModel.topCrew)
                InfoTable(info: movieViewModel.infoArray)
            }
        }
        .onAppear {
            movieViewModel.refresh()
        }
        .preferredColorScheme(.dark)
    }
}
