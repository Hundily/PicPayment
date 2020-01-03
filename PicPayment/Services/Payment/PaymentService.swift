//
//  PaymentService.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 26/12/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

protocol PaymentServiceProtocol  {
    func fetchPayment(paymentTransaction: Payment, completion: @escaping (ServiceResult<Payment>) -> Void)
}

final class PaymentService: NSObject, PaymentServiceProtocol {
    
    private let serviceProtocol: ServiceClientProtocol
    
    override init() {
        self.serviceProtocol = ServiceClient()
    }
    
    init(service: ServiceClientProtocol) {
        self.serviceProtocol = service
    }
    
    func fetchPayment(paymentTransaction: Payment, completion: @escaping (ServiceResult<Payment>) -> Void) {
        let router = PaymentRouter.fetchPayment(paymentTransaction)
        self.serviceProtocol.request(router: router) { (response: ServiceResult<Payment>) in
            switch response {
            case let .success(value):
                if value != nil {
                    completion(.failure(.empty(.payment)))
                }
            completion(.success(value))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
