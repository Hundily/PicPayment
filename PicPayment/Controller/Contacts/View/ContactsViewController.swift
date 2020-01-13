//
//  ContactsViewController.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit
import FittedSheets

final class ContactsViewController: UIViewController {
    
    // MARK: UI
    private lazy var backGroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = ColorName.backgroundDefault.color
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.searchBar.placeholder = L10n.placeHolderSearch
        return search
    }()
    
    private lazy var presenter: ContactPresenter = {
        let presenter = ContactPresenter(viewProtocol: self, serviceAPI: ContactService())
        return presenter
    }()
    
    var didRequestToNextView: ((Contact) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupUI()
        setupTableView()
        presenter.fetchContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }
    
    private func setupUI() {
        UITextField.appearance().keyboardAppearance = .dark
    }
    
    private func setupNavigation() {
        setupNavigationBar(with: .default, prefersLargeTitles: true)
        self.navigationItem.title = L10n.contacts
        navigationController?.navigationBar.tintColor = ColorName.green.color
        navigationController?.view.backgroundColor = ColorName.backgroundDefault.color
        navigationItem.searchController = searchController
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInsetAdjustmentBehavior = .automatic
        self.view.backgroundColor = UIColor(named: .backgroundDefault)
        self.tableView.register(ContactViewCell.self)
        self.tableView.register(ContactErrorViewCell.self)
        self.tableView.register(LoadingViewCell.self)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContactsViewController: CodeViewProtocol {
    func buildViewHierarchy() {
        view.addSubview(backGroundView)
        backGroundView.addSubview(tableView)
    }
    
    func setupConstraints() {
        backGroundView.anchor(top: view.topAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.trailingAnchor,
                              insets: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        tableView.anchor(top: backGroundView.topAnchor,
                         leading: backGroundView.leadingAnchor,
                         bottom: backGroundView.bottomAnchor,
                         trailing: backGroundView.trailingAnchor,
                         insets: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
}

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactType = presenter.getContact(by: indexPath.row)
        switch contactType {
        case let .cell(contact):
            presenter.handleTapOnContact(contact)
        default:
            break
        }
    }
}

extension ContactsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getCountContacts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactItem = presenter.getContact(by: indexPath.row)
        switch contactItem {
        case let .cell(contact):
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ContactViewCell
            cell.configure(contact: contact)
            return cell
        case let .error(error):
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ContactErrorViewCell
            cell.setupCell(error: error) { [weak self] in
                guard let self = self else { return }
                self.presenter.fetchContacts()
            }
            return cell
        case .loading:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LoadingViewCell
            cell.setup()
            return cell
        }
    }
}

extension ContactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty {
            presenter.filterContacts(by: searchText)
        }
    }
}

extension ContactsViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setLayoutEnable()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setLayoutDisable()
        presenter.clearFilterContacts()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.setLayoutDisable()
    }
}

extension ContactsViewController: ContactProtocol {
    func show() {
        tableView.reloadData()
    }
    
    func show(error: Error) {
        print(error.localizedDescription)
    }
    
    func routerPayment(contact: Contact, creditCard: CreditCard) {
        let payment = PaymentViewController(contact: contact, creditCard: creditCard)
        self.navigationController?.present(payment, style: .push(animated: true))
    }
    
    func routerHomeCreditCard(contact: Contact) {
        let navController = UINavigationController(rootViewController: RegisterCreditCardHomeViewController(contact: contact))
        self.navigationController?.present(navController, style: .present(animated: true))
    }
}
