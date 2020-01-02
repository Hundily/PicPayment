// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSFont
  internal typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
  internal typealias Font = UIFont
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum SFUIText {
    internal static let bold = FontConvertible(name: "SFUIText-Bold", family: "SF UI Text", path: "SFUIText-Bold.ttf")
    internal static let boldItalic = FontConvertible(name: "SFUIText-BoldItalic", family: "SF UI Text", path: "SFUIText-BoldItalic.ttf")
    internal static let heavy = FontConvertible(name: "SFUIText-Heavy", family: "SF UI Text", path: "SFUIText-Heavy.ttf")
    internal static let heavyItalic = FontConvertible(name: "SFUIText-HeavyItalic", family: "SF UI Text", path: "SFUIText-HeavyItalic.ttf")
    internal static let light = FontConvertible(name: "SFUIText-Light", family: "SF UI Text", path: "SFUIText-Light.ttf")
    internal static let lightItalic = FontConvertible(name: "SFUIText-LightItalic", family: "SF UI Text", path: "SFUIText-LightItalic.ttf")
    internal static let medium = FontConvertible(name: "SFUIText-Medium", family: "SF UI Text", path: "SFUIText-Medium.ttf")
    internal static let mediumItalic = FontConvertible(name: "SFUIText-MediumItalic", family: "SF UI Text", path: "SFUIText-MediumItalic.ttf")
    internal static let regular = FontConvertible(name: "SFUIText-Regular", family: "SF UI Text", path: "SFUIText-Regular.ttf")
    internal static let italic = FontConvertible(name: "SFUIText-RegularItalic", family: "SF UI Text", path: "SFUIText-RegularItalic.ttf")
    internal static let semibold = FontConvertible(name: "SFUIText-Semibold", family: "SF UI Text", path: "SFUIText-Semibold.ttf")
    internal static let semiboldItalic = FontConvertible(name: "SFUIText-SemiboldItalic", family: "SF UI Text", path: "SFUIText-SemiboldItalic.ttf")
    internal static let all: [FontConvertible] = [bold, boldItalic, heavy, heavyItalic, light, lightItalic, medium, mediumItalic, regular, italic, semibold, semiboldItalic]
  }
  internal static let allCustomFonts: [FontConvertible] = [SFUIText.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  internal func font(size: CGFloat) -> Font! {
    return Font(font: self, size: size)
  }

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    let bundle = Bundle(for: BundleToken.self)
    return bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension Font {
  convenience init!(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(OSX)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

private final class BundleToken {}
