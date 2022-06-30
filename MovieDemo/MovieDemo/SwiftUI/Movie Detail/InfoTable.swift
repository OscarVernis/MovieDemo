//
//  InfoTable.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 29/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct InfoItemModel: Hashable {
    var title: String
    var subtitle: String
}

struct InfoTable: View {
    var items: [InfoItemModel] = Array<InfoItemModel>(repeating: InfoItemModel(title: "Test", subtitle: "Test"), count: 20)
    
    let columns: [GridItem]
    
    init(credits: [CrewCreditViewModel], columns: Int = 2) {
        self.items = credits.map {
            InfoItemModel(title: $0.name, subtitle: $0.jobs ?? "")
        }
        
        self.columns = Array<GridItem>(repeating: GridItem(.flexible()), count: columns)
    }
    
    init(info: [[String : String]], columns: Int = 1) {
        self.items = info.compactMap {
            guard let title = $0.keys.first, let subtitle = $0.values.first else { return nil}
            
            return InfoItemModel(title: title, subtitle: subtitle)
        }
            
        self.columns = Array<GridItem>(repeating: GridItem(.flexible()), count: columns)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(items, id: \.self) { item in
                    InfoItem(title: item.title, subtitle: item.subtitle)
                }
            }
            .padding([.leading, .trailing], 20)
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
