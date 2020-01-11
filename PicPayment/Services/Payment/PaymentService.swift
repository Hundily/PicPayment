//
//  PaymentService.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 26/12/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

protocol PaymentServiceProtocol  {
    func fetchPayment(paymentTransaction: Payment, completion: @escaping (ServiceResult<PaymentResponse>) -> Void)
}

final class PaymentService: NSObject, PaymentServiceProtocol {
    
    private let serviceProtocol: ServiceClientProtocol
    
    override init() {
        self.serviceProtocol = ServiceClient()
    }
    
    init(service: ServiceClientProtocol) {
        self.serviceProtocol = service
    }
    
    func fetchPayment(paymentTransaction: Payment, completion: @escaping (ServiceResult<PaymentResponse>) -> Void) {
        let router = PaymentRouter.fetchPayment(paymentTransaction)
        print("router", router)

        self.serviceProtocol.request(router: router) { (response: ServiceResult<PaymentResponse>) in
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
