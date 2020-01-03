//
//  HomePaymentPresenter.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 03/01/20.
//  Copyright © 2020 PicPayment. All rights reserved.
//

import Foundation

final class HomePaymentPresenter {
    
    private let viewProtocol: HomePaymentProtocol
    private let service: PaymentService
    
    init(viewProtocol: HomePaymentProtocol, serviceAPI: PaymentService) {
        self.viewProtocol = viewProtocol
        self.service = serviceAPI
    }
    
    func fetchPayment(payment: Payment) {
        viewProtocol.showLoading()

        self.service.fetchPayment(paymentTransaction: payment) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                print(response)
            case .failure(let error):
                self.viewProtocol.show(error: error)
            }
        }

        viewProtocol.dismissLoading()
    }
}
