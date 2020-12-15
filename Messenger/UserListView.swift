//
//  UserListView.swift
//  Messenger
//
//  Created by Zeno on 10/12/2020.
//

import SwiftUI
import MessengerInterface
import KingfisherSwiftUI

struct UserListView: View {
    
    @EnvironmentObject
    var controller: ConversationController
    
    @State
    var selectedChannel: Channel?
    
    @State
    var isSelected: Bool = false
    
    @State
    var selectedUser: User?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(controller.users, id: \User.id) { (user) in
                    VStack {
                        if let channel = selectedChannel, user.id == selectedUser?.id {
                            NavigationLink(destination: MessageListView().environmentObject(ChatController(channel: channel)),
                                           isActive: $isSelected) {
                                Text("")
                            }.disabled(selectedUser?.id != user.id )
                        }
                        
                        Button(action: {
                            controller.createConversation(with: user, completion: { channel, error in
                                guard let channel = channel else { return }
                                selectedChannel = channel
                                isSelected = true
                                selectedUser = user
                            })
                        }) {
                            VStack {
                                KFImage(URL(string: user.profileUrl ?? "")!)
                                    .resizable()
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .clipShape(Circle())
                                Text(user.nickName ?? "").font(.body)
                            }.padding(2)
                        }
                    }
                    
                }
            }
        }
    }
}
