//
//  ContactService.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

protocol ContactServiceProtol  {
    func fetchContacts(completion: @escaping (ServiceResult<[Contact]>) -> Void)
}

final  class ContactService: NSObject, ContactServiceProtol {
    
    private let serviceProtocol: ServiceClientProtocol
    
    override init() {
        self.serviceProtocol = ServiceClient()
    }
    
    init(service: ServiceClientProtocol) {
        self.serviceProtocol = service
    }
    
    func fetchContacts(completion: @escaping (ServiceResult<[Contact]>) -> Void) {
        let router = ContactRouter.fetchContact
        self.serviceProtocol.request(router: router) { (response: ServiceResult<[Contact]>) in
            switch response {
            case let .success(value):
                if value.isEmpty {
                    completion(.failure(.empty(.contact)))
                }
                completion(.success(value))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
