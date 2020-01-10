//
//  HomeTransferPresenter.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 03/01/20.
//  Copyright © 2020 PicPayment. All rights reserved.
//

import Foundation

final class HomeTransferPresenter {
    
    private let viewProtocol: HomeTransferProtocol
    private let service: TransferService
    
    init(viewProtocol: HomeTransferProtocol, serviceAPI: TransferService) {
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
