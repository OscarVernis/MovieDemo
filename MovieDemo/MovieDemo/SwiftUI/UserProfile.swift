//
//  UserProfile.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import SwiftUI

struct UserProfile: View {
    @ObservedObject var user: UserViewModel
    weak var coordinator: MainCoordinator?

    var body: some View {
        if let username = user.username {
            Text(username)
        } else {
            Text("Loading...")
                .onAppear {
                    refresh()
                }
        }
    }
    
    func refresh() {
        user.updateUser()
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
//        UserProfile()
    }
}
