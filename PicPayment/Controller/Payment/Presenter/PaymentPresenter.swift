//
//  PaymentPresenter.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/01/20.
//  Copyright © 2020 PicPayment. All rights reserved.
//

import Foundation

final class PaymentPresenter {
    
    private let viewProtocol: PaymentProtocol
    private let service: PaymentService
    
    init(viewProtocol: PaymentProtocol, serviceAPI: PaymentService) {
        self.viewProtocol = viewProtocol
        self.service = serviceAPI
    }
    
    func fetchPayment(payment: Payment) {
        viewProtocol.showLoading()
        
        self.service.fetchPayment(payment: payment) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(payment):
                print("payment", payment)
            case let.failure(error):
                print("error", error)
                self.viewProtocol.dismissLoading()
                self.viewProtocol.show(error: error)
            }
        }
    }
}
