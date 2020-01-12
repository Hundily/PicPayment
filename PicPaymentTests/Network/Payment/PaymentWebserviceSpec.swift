//
//  PaymentWebserviceSpec.swift
//  PicPaymentTests
//
//  Created by Hundily Cerqueira on 11/01/20.
//  Copyright © 2020 PicPayment. All rights reserved.
//

import Nimble
import Quick
@testable import PicPayment

final class PaymentWebserviceSpec: QuickSpec {
    
    override func spec() {
        
        describe("Test Payment webservice") {
            
            context("") {
                
                var webService = PaymentService()
                
                it("return payment success") {
                    let paymentParam = Payment(card_number: "1111111111111111", cvv: 789, value: 79.9, expiry_date: "01/18", destination_user_id: 1002)
                    
                    webService = PaymentService(service: MockWebservice(type: .payment))
                    webService.fetchPayment(payment: paymentParam) { (result) in
                        switch result {
                        case .success:
                            expect(true) == true
                        case .failure:
                            XCTFail()
                        }
                    }
                }
                
                it("return payment fail") {
                    let paymentParam = Payment(card_number: "1111111111111111", cvv: 789, value: 79.9, expiry_date: "01/18", destination_user_id: 1002)
                    
                    webService = PaymentService(service: MockWebservice(type: .unexpectedError))
                    webService.fetchPayment(payment: paymentParam) { (result) in
                        switch result {
                        case .success:
                            XCTFail()
                        case let .failure(error):
                            expect(error) == .unexpected
                        }
                    }
                }
            }
        }
    }
}

