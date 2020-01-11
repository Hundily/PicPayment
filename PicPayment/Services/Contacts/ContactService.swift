//
//  ContactService.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

protocol ContactServiceProtocol  {
    typealias ContactResult = Result<[Contact], WebserviceError>
    func fetchContact(completion: @escaping (ContactResult) -> Void)
}

final  class ContactService: NSObject, ContactServiceProtocol {
    
    let service: Webservice
    
    init(service: Webservice = BaseWebservice()) {
        self.service = service
    }

    func fetchContact(completion: @escaping (ContactResult) -> Void) {
        service.request(urlString: API.Path.contacts.value, method: .get) { (result: ContactResult) in
            switch result {
            case let .success(contact):
                completion(.success(contact))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
