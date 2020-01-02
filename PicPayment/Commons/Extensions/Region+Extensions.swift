//
//  Region+Extensions.swift
//  BankApp
//
//  Created by Hundily Cerqueira on 16/07/19.
//  Copyright © 2019 Hundily Cerqueira Silva. All rights reserved.
//

import Foundation
import SwiftDate

extension Region {
    static let brazil = Region(calendar: Calendars.gregorian,
                               zone: Zones.americaSaoPaulo,
                               locale: Locales.portugueseBrazil)
}

