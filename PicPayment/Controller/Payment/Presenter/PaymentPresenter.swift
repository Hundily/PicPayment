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
    private let service: TransferService
    
    init(viewProtocol: PaymentProtocol, serviceAPI: TransferService) {
        self.viewProtocol = viewProtocol
        self.service = serviceAPI
    }
    
    func fetchPayment(payment: Transfer) {
        viewProtocol.showLoading()

        self.service.fetchTransfer(paymentTransaction: payment) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.viewProtocol.dismissLoading()
                self.viewProtocol.goReceiptView()
            case .failure(let error):
                self.viewProtocol.dismissLoading()
                self.viewProtocol.show(error: error)
                self.viewProtocol.goReceiptView()
            }
        }

//        viewProtocol.dismissLoading()
    }
}
