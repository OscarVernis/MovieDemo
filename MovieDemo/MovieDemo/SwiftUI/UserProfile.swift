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
        ZStack(alignment: .top) {
            if let url = user.avatarURL {
                BlurBackground(url: url)
            }
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .center, spacing: 0) {
                    if let username = user.username, let url = user.avatarURL {
                        userHeader(url, username)
                    } else {
                        loading()
                    }
                }
            }
        }
    }
    
    fileprivate func userHeader(_ url: URL, _ username: String) -> some View {
        VStack(spacing: 0) {
            RemoteImage(url: url, placeholder: Image(asset: .person))
                .frame(width: 142, height: 142)
                .clipShape(Circle())
                .padding(.bottom, 17)
            Text(username)
                .titleStyle()
                .padding(.bottom, 30)
            Button {
                coordinator?.logout()
            } label: {
                HStack {
                    Image(asset: .person)
                    Text("Logout")
                }
            }
            .tint(Color(asset: .AppTintColor))
            .buttonStyle(.bordered)
        }
    }
    
    fileprivate func loading() -> some View {
        return Text("Loading...")
            .onAppear {
                refresh()
            }
    }
    
    func refresh() {
        user.updateUser()
    }
}

struct BlurBackground: View {
    var url: URL
    
    internal init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        ZStack {
            RemoteImage(url: url)
                .scaledToFill()
                .clipped()
                .ignoresSafeArea()
            Rectangle()
                .fill(.clear)
                .background(.thickMaterial)
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var user = UserViewModel(service: JSONUserLoader(filename: "user"),
                                    cache: nil)
    
    static var previews: some View {
        NavigationView {
            UserProfile(user: user)
                .preferredColorScheme(.dark)
        }
    }
}
