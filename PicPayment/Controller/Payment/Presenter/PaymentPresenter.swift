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
                self.viewProtocol.dismissLoading()
                self.viewProtocol.showReceiptView(receipt: self.paymentReceiptModel(type: payment))
            case let.failure(error):
                self.viewProtocol.dismissLoading()
                self.viewProtocol.show(error: error)
            }
        }
    }
    
    func paymentReceiptModel(type paymentResponse: PaymentResponse) -> PaymentReceipt? {
        if let res = paymentResponse.transaction {
            let receipt = PaymentReceipt(id: res.id ?? 0, transactionDate: "\(res.timestamp ?? 0)", img: res.destination_user?.img ?? "", username: res.destination_user?.username ?? "", value: res.value ?? 0.0)
            
            return receipt
        }
        
        return nil
    }
}
