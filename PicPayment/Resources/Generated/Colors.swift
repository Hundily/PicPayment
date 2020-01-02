// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSColor
  internal typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  internal typealias Color = UIColor
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Colors

// swiftlint:disable identifier_name line_length type_body_length
internal struct ColorName {
  internal let rgbaValue: UInt32
  internal var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1d1e20"></span>
  /// Alpha: 100% <br/> (0x1d1e20ff)
  internal static let backgroundDefault = ColorName(rgbaValue: 0x1d1e20ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#111112"></span>
  /// Alpha: 100% <br/> (0x111112ff)
  internal static let grayStrong = ColorName(rgbaValue: 0x111112ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#11c76f"></span>
  /// Alpha: 100% <br/> (0x11c76fff)
  internal static let green = ColorName(rgbaValue: 0x11c76fff)
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

// swiftlint:disable operator_usage_whitespace
internal extension Color {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
// swiftlint:enable operator_usage_whitespace

internal extension Color {
  convenience init(named color: ColorName) {
    self.init(rgbaValue: color.rgbaValue)
  }
}
