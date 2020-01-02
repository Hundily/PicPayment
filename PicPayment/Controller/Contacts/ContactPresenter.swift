//
//  ContactPresenter.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

final class ContactPresenter {
    
    private let viewProtocol: ContactProtocol
    private let service: ContactService
    
    private var allContacts: [ContactListCellType<Contact>] = [] {
        didSet {
            self.viewProtocol.show()
        }
    }
    
    private var filterContacts: [ContactListCellType<Contact>] = [] {
        didSet {
            self.viewProtocol.show()
        }
    }
    
    init(viewProtocol: ContactProtocol, serviceAPI: ContactService) {
        self.viewProtocol = viewProtocol
        self.service = serviceAPI
    }
    
    func fetchContacts() {
        allContacts = [.loading]
        self.service.fetchContacts(){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.allContacts = response.map {
                    return ContactListCellType.cell($0)
                }
            case .failure(let error):
                print(error)
                self.allContacts = [ContactListCellType.error(error)]
            }
        }
    }
}

extension ContactPresenter {
    
    func getCountContacts() -> Int {
        if filterContacts.count > 0 {
            return filterContacts.count
        }
        return allContacts.count
    }
    
    func getContact(by index: Int) -> ContactListCellType<Contact> {
        if filterContacts.count > 0 {
            return filterContacts[index]
        }
        return allContacts[index]
    }
    
    func filterContacts(by name: String) {
        let listFilter = allContacts.filter {
            switch $0 {
            case let .cell(contact):
                return contact.name.uppercased().contains(name.uppercased())
                    || contact.username.uppercased().contains(name.uppercased())
            default:
                return false
            }
        }
        if listFilter.isEmpty {
            filterContacts = [.error(.empty(.contact))]
        } else {
            filterContacts = listFilter
        }
    }
    
    func clearFilterContacts() {
        self.filterContacts = []
    }
}
