//
//  AttributedText.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 21/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI
import UIKit

struct AttributedText: UIViewRepresentable {
    typealias UIViewType = UILabel

    @Binding var text: NSMutableAttributedString

    func makeUIView(context: UIViewRepresentableContext<AttributedText>) -> UILabel {
        UILabel()
    }

    func updateUIView(_ uiView: UILabel, context: UIViewRepresentableContext<AttributedText>) {
        uiView.attributedText = text
    }
}
