//
//  ConversationView.swift
//  Messenger
//
//  Created by Zeno on 10/12/2020.
//

import SwiftUI
import MessengerInterface

struct ConversationView: View {
    @EnvironmentObject
    var conversationController: ConversationController
    
    var body: some View {
        VStack {
            UserListView().environmentObject(conversationController)
            Spacer()
            ConversationListView().environmentObject(conversationController)
        }.navigationTitle("Conversations")
        
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView()
    }
}
