// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Contatos
  internal static let contacts = L10n.tr("Localizable", "contacts")
  /// Para fazer pagamentos para outras pessoas você precisa cadastrar um cartão de crédito pessoal.
  internal static let descriptionCreditCard = L10n.tr("Localizable", "descriptionCreditCard")
  /// Editar Cartão
  internal static let editCard = L10n.tr("Localizable", "editCard")
  /// Não foi possível encontrar os contatos.
  internal static let errorEmptyStateDescriptionContact = L10n.tr("Localizable", "errorEmptyStateDescriptionContact")
  /// Não foi possível realizar o pagamento nesse momento.
  internal static let errorEmptyStateDescriptionPaymento = L10n.tr("Localizable", "errorEmptyStateDescriptionPaymento")
  /// Sem Contatos
  internal static let errorEmptyStateTitleContact = L10n.tr("Localizable", "errorEmptyStateTitleContact")
  /// Não foi possível realizar o pagamento
  internal static let errorFetchPayment = L10n.tr("Localizable", "errorFetchPayment")
  /// Não foi possível carregar a página no momento
  internal static let errorInternetDescription = L10n.tr("Localizable", "errorInternetDescription")
  /// Sem conexão com internet
  internal static let errorInternetTitle = L10n.tr("Localizable", "errorInternetTitle")
  /// Não foi possivel carregar a página no momento. Por favor, tente mais tarde.
  internal static let errorUnexpectedDescription = L10n.tr("Localizable", "errorUnexpectedDescription")
  /// Erro inesperado
  internal static let errorUnexpectedTitle = L10n.tr("Localizable", "errorUnexpectedTitle")
  /// CVV inválido
  internal static let invalidCvv = L10n.tr("Localizable", "invalidCvv")
  /// Validade inválida
  internal static let invalidExpired = L10n.tr("Localizable", "invalidExpired")
  /// Número inválido
  internal static let invalidNumber = L10n.tr("Localizable", "invalidNumber")
  /// Pagar
  internal static let payment = L10n.tr("Localizable", "payment")
  /// Recibo
  internal static let paymentReceipt = L10n.tr("Localizable", "paymentReceipt")
  /// A quem você deseja pagar?
  internal static let placeHolderSearch = L10n.tr("Localizable", "placeHolderSearch")
  /// Cadastrar cartão
  internal static let registerCard = L10n.tr("Localizable", "registerCard")
  /// Salvar
  internal static let saveCreditCard = L10n.tr("Localizable", "saveCreditCard")
  /// teste
  internal static let teste = L10n.tr("Localizable", "teste")
  /// Cadastre um cartão de crédito
  internal static let titleCreditCard = L10n.tr("Localizable", "titleCreditCard")
  /// Total pago
  internal static let totalPaid = L10n.tr("Localizable", "totalPaid")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
