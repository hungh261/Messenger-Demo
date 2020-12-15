//
//  ConversationListView.swift
//  Messenger
//
//  Created by Zeno on 11/12/2020.
//

import SwiftUI
import MessengerInterface
import KingfisherSwiftUI

struct ConversationListView: View {
    @EnvironmentObject
    var controller: ConversationController
    
    @State
    var selectedChannel: Channel?
    
    @State
    var selectedUser: User?
    
    var body: some View {
        List {
            ForEach(controller.channels, id: \.id) { (channel) in
                VStack {
                    NavigationLink(destination: MessageListView().environmentObject(ChatController(channel: channel))) {
                        HStack {
                            KFImage(URL(string: channel.channelAvararUrl ?? "")!)
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text(channel.title).font(.headline)
                                if let lastMesg = channel.lastMessage?.message {
                                    Text(lastMesg).font(Font.callout)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
