//
//  PaymentService.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 26/12/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

protocol PaymentServiceProtocol  {
    typealias PaymentResult = Result<PaymentResponse, WebserviceError>
    func fetchPayment(payment: Payment, completion: @escaping (PaymentResult) -> Void)
}

final  class PaymentService: NSObject, PaymentServiceProtocol {
    
    let service: Webservice
    
    init(service: Webservice = BaseWebservice()) {
        self.service = service
    }

    func fetchPayment(payment: Payment, completion: @escaping (PaymentResult) -> Void) {
        let parameters: [String: Any] = [
            "card_number": payment.card_number,
            "cvv": payment.cvv,
            "value": payment.value,
            "expiry_date": payment.expiry_date,
            "destination_user_id": payment.destination_user_id
        ]

        service.request(urlString: API.Path.payment.value, method: .post, parameters: parameters) { (result: PaymentResult) in
            switch result {
            case let .success(payment):
                completion(.success(payment))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
