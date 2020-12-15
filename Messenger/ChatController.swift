//
//  ChatController.swift
//  Messenger
//
//  Created by Zeno on 11/25/20.
//

import SwiftUI
import Combine
import MessengerInterface
import RxSwift

final class ChatController: ObservableObject {
    // didChange will let the SwiftUI know that some changes have happened in this object
    // and we need to rebuild all the views related to that object
    var didChange = PassthroughSubject<Void, Never>()
    let channel: Channel
    let messageCollection: MessagesCollectionType
    let disposeBag = DisposeBag()
    
    init(channel: Channel) {
        self.channel = channel
        messageCollection = ConfigsManager.config.createMessageCollection(limit: 20, channel: channel)
        messageCollection
            .observeChannelMessages()
            .distinctUntilChanged()
            .map { $0.sorted { $0.createdAt > $1.createdAt } }
            .observeOn(MainScheduler.instance).subscribeNext { [weak self] (list) in
                self?.messages = list
                self?.didChange.send(())
            }
            .disposed(by: disposeBag)
        messageCollection.refresh()
    }
    
    // We've relocated the messages from the main SwiftUI View. Now, if you wish, you can handle the networking part here and populate this array with any data from your database. If you do so, please share your code and let's build the first global open-source chat app in SwiftUI together
    // It has to be @Published in order for the new updated values to be accessible from the ContentView Controller
    @Published
    var messages: [Message] = []
    
    // this function will be accessible from SwiftUI main view
    // here you can add the necessary code to send your messages not only to the SwiftUI view, but also to the database so that other users of the app would be able to see it
    func sendTextMessage(_ text: String) {
        let message = Message(message: text, metaData: nil)
        messageCollection.addNewMessage(message).subscribe().disposed(by: disposeBag)
    }
}

extension Message: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(message)
    }
}
