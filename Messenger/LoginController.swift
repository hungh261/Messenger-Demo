//
//  LoginController.swift
//  Messenger
//
//  Created by Zeno on 09/12/2020.
//

import Foundation
import Combine
import MessengerFirestore
import MessengerInterface
import RxCocoa
import RxSwift

final class LoginController: ObservableObject {
    enum Error: Swift.Error {
        case missingUserId
    }
    var didChange = PassthroughSubject<Void, Never>()
    var authenticationService: AuthenticationServiceType
    let disposeBag = DisposeBag()
    
    @Published
    var isAuthenticated = false
    
    init(authenticationService: AuthenticationServiceType) {
        self.authenticationService = authenticationService
        isAuthenticated = ConfigsManager.config.userManager.currentUserId != nil
    }
    
    func login(email: String, password: String, nickName: String?) {
        authenticationService.prepareAuthenWith(method: .email(email: email, password: password))
        ConfigsManager
            .config
            .connection
            .connect()
            .flatMap({ (_) -> Single<Void> in
                guard let uid = ConfigsManager.config.userManager.currentUserId else { return Single<Void>.error(LoginController.Error.missingUserId) }
                let user = BasicUser(uId: uid, nickName: nickName, profileUrl: "https://lh3.googleusercontent.com/ogw/ADGmqu-5IB6ruD7k4a55WI6ucWF-kdpfqfTlyDQmP8LKOw=s192-c-mo")
                return ConfigsManager.config.sourceModelCreator.createIfNotExistUser(user: user)
            })
            .debug()
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] (_) in
                self?.isAuthenticated = true
                self?.didChange.send(())
            }, onError: nil).disposed(by: disposeBag)
    }
    
    func logout() {
        ConfigsManager
            .config
            .connection
            .disconnect()
            .debug().subscribe(onSuccess: { [weak self] (_) in
                self?.isAuthenticated = false
                self?.didChange.send(())
            }, onError: nil).disposed(by: disposeBag)
    }
}
