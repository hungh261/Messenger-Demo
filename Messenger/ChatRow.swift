//
//  ChatRow.swift
//  Messenger
//
//  Created by Zeno on 11/25/20.
//

import Foundation
import SwiftUI
import MessengerInterface

struct ChatRow: View {
    var message: Message
    var isMe: Bool {
        message.sender?.isCurrent ?? false
    }
    var body: some View {
        HStack {
            if !isMe {
                Group {
                    Text(message.message ?? "")
                        .bold()
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.orange)
                        .cornerRadius(10)
                    Spacer()
                }
            } else {
                Group {
                    Spacer()
                    Text(message.message ?? "")
                        .bold()
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
    }
}
