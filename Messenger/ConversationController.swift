//
//  ConversationController.swift
//  Messenger
//
//  Created by Zeno on 10/12/2020.
//

import Foundation
import Combine
import MessengerInterface
import RxSwift

final class ConversationController: ObservableObject {
    var userManagerment: UserManagerType
    var sourceCreator: SourceModelCreatorType
    var channelCollection: ChannelsCollectionType
    let disposeBag = DisposeBag()
    
    var didChange = PassthroughSubject<Void, Never>()
    
    @Published
    var users: [User] = []
    
    @Published
    var channels: [Channel] = []
    
    init() {
        userManagerment = ConfigsManager.config.userManager
        sourceCreator = ConfigsManager.config.sourceModelCreator
        channelCollection = ConfigsManager.config.createChannelCollection(limit: 20)
        userManagerment
            .availableUserList(includeCurrent: false)
            .observeOn(MainScheduler.instance)
            .subscribeNext { [weak self] (list) in
                self?.users = list
                self?.didChange.send(())
            }
            .disposed(by: disposeBag)
        channelCollection.observeMyChannels().distinctUntilChanged().observeOn(MainScheduler.instance).subscribeNext { [weak self] (list) in
            self?.channels = list
            self?.didChange.send(())
        }.disposed(by: disposeBag)
    }
    
    func createConversation(with user: User, completion: @escaping ((Channel?, Error?) -> Void)) {
        sourceCreator.createChannelForUsers([user.user], title: "").debug().do(onSuccess: { (channel) in
            completion(channel, nil)
        }, onError: { (error) in
            completion(nil, error)
        }).subscribe().disposed(by: disposeBag)
    }
}
