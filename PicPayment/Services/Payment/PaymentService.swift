//
//  PaymentService.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 26/12/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

protocol PaymentServiceProtol  {
    func fetchPayment(paymentTransaction: Payment, completion: @escaping (ServiceResult<Payment>) -> Void)
}

final  class PaymentService: NSObject, PaymentServiceProtol {
    
    private let serviceProtocol: ServiceClientProtocol
    
    override init() {
        self.serviceProtocol = ServiceClient()
    }
    
    init(service: ServiceClientProtocol) {
        self.serviceProtocol = service
    }
    
    func fetchPayment(paymentTransaction: Payment, completion: @escaping (ServiceResult<Payment>) -> Void) {
        let router = PaymentRouter.fetchPayment
        self.serviceProtocol.request(router: router) { (response: ServiceResult<Contact>) in
            switch response {
            case let .success(_): break
//                if value.isEmpty {
//                    completion(.failure(.empty(.contact)))
//                }
//                completion(.success(value))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
