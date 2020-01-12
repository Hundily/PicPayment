//
//  ContactsWebserviceSpec.swift
//  PicPaymentTests
//
//  Created by Hundily Cerqueira on 11/01/20.
//  Copyright © 2020 PicPayment. All rights reserved.
//

import Nimble
import Quick
@testable import PicPayment

final class ContactsWebserviceSpec: QuickSpec {
    
    override func spec() {
        
        describe("Test Contacts webservice") {
         
            context("") {
             
                var webService = ContactService()
                
                it("return  a valid contacts if webservice return") {
                    webService = ContactService(service: MockWebservice(type: .contacts))
                    webService.fetchContact { (result) in
                        switch result {
                        case .success:
                            expect(true) == true
                        case .failure:
                            XCTFail()
                        }
                    }
                }
                
                it("return empty error after webservice returns a success") {
                    webService = ContactService(service: MockWebservice(type: .unexpectedError))
                    webService.fetchContact { (result) in
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

