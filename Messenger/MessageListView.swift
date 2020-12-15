//
//  ContentView.swift
//  Messenger
//
//  Created by Zeno on 11/25/20.
//

import SwiftUI

struct MessageListView: View {
    // @State here is necessary to make the composedMessage variable accessible from different views
    @State var composedMessage: String = ""
    @EnvironmentObject
    var chatController: ChatController
    
    var body: some View {
        
        // the VStack is a vertical stack where we place all our substacks like the List and the TextField
        VStack {
            List {
                ForEach(chatController.messages, id: \.id) { msg in
                    ChatRow(message: msg).flip()
                }
            }.flip()
            
            // TextField are aligned with the Send Button in the same line so we put them in HStack
            HStack {
                // this textField generates the value for the composedMessage @State var
                TextField("Message...", text: $composedMessage).frame(minHeight: CGFloat(30))
                // the button triggers the sendMessage() function written in the end of current View
                Button(action: sendMessage) {
                    Text("Send")
                }
            }.frame(minHeight: CGFloat(50)).padding()
            // that's the height of the HStack
        }.navigationTitle(chatController.channel.title)
    }
    
    func sendMessage() {
        chatController.sendTextMessage(composedMessage)
        composedMessage = ""
    }
}

extension View {
    public func flip() -> some View {
        return self
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}
