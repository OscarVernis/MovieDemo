//
//  Separator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 16/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct Separator: View {
    var body: some View {
        Rectangle()
            .fill(Color(uiColor: .separator))
            .frame(height: 0.5)
            .padding(0)
    }
}

struct Separator_Previews: PreviewProvider {
    static var previews: some View {
        Separator()
    }
}
