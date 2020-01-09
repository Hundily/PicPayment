//
//  RegisterCreditCardFormPresenter.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 08/01/20.
//  Copyright © 2020 PicPayment. All rights reserved.
//

import Foundation

final class RegisterCreditCardFormPresenter {
    
    private let viewProtocol: RegisterCreditCardFormProtocol
    private var creditCard: CreditCard?
    private var contact: Contact?
    
    init(viewProtocol: RegisterCreditCardFormProtocol) {
        self.viewProtocol = viewProtocol
    }
    
    func registerCreditCard(creditCard: CreditCard) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(creditCard) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "CREDIT_CARD")
            viewProtocol.registerCardSuccess()
        } else {
            viewProtocol.registerCardError()
        }
    }
}

extension RegisterCreditCardFormPresenter {
    
    func creditCardData() {
        if let cardPase = UserDefaults.standard.object(forKey: "CREDIT_CARD") as? Data {
            let decoder = JSONDecoder()
            if let card = try? decoder.decode(CreditCard.self, from: cardPase) {
                self.creditCard = card
            }
        }
    }
    
    func setContact(contact: Contact) {
        self.contact = contact
    }
    
    func getCard() -> CreditCard? {
        return self.creditCard
    }
}

