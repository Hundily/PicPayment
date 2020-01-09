//
//  TransferService.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 26/12/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

protocol TransferServiceProtocol  {
    func fetchTransfer(paymentTransaction: Transfer, completion: @escaping (ServiceResult<Transfer>) -> Void)
}

final class TransferService: NSObject, TransferServiceProtocol {
    
    private let serviceProtocol: ServiceClientProtocol
    
    override init() {
        self.serviceProtocol = ServiceClient()
    }
    
    init(service: ServiceClientProtocol) {
        self.serviceProtocol = service
    }
    
    func fetchTransfer(paymentTransaction: Transfer, completion: @escaping (ServiceResult<Transfer>) -> Void) {
        let router = PaymentRouter.fetchPayment(paymentTransaction)
        print("router", router)

        self.serviceProtocol.request(router: router) { (response: ServiceResult<Transfer>) in
            switch response {
            case let .success(value):
                print(value)
                if value != nil {
                    completion(.failure(.empty(.payment)))
                }
            completion(.success(value))
            case let .failure(error):
                print("error", error)
                completion(.failure(error))
            }
        }
    }
}
