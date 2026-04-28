// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset {
  public static let accentColor = ColorAsset(name: "AccentColor")
  public static let authCardViewColor = ColorAsset(name: "authCardViewColor")
  public static let backgroundGray = ColorAsset(name: "backgroundGray")
  public static let backgroundGreen = ColorAsset(name: "backgroundGreen")
  public static let backgroundLightPink = ColorAsset(name: "backgroundLightPink")
  public static let darkPink = ColorAsset(name: "darkPink")
  public static let lightGreen = ColorAsset(name: "lightGreen")
  public static let lightPink = ColorAsset(name: "lightPink")
  public static let lightPurple = ColorAsset(name: "lightPurple")
  public static let lightRed = ColorAsset(name: "lightRed")
  public static let midPurple = ColorAsset(name: "midPurple")
  public static let petGray = ColorAsset(name: "petGray")
  public static let petGreen = ColorAsset(name: "petGreen")
  public static let petGreenAction = ColorAsset(name: "petGreenAction")
  public static let petLightGray = ColorAsset(name: "petLightGray")
  public static let petPink = ColorAsset(name: "petPink")
  public static let petPinkAction = ColorAsset(name: "petPinkAction")
  public static let petPurple = ColorAsset(name: "petPurple")
  public static let petPurpleAction = ColorAsset(name: "petPurpleAction")
  public static let petYellow = ColorAsset(name: "petYellow")
  public static let pinkAccent = ColorAsset(name: "pinkAccent")
  public static let pinkAccentStatus = ColorAsset(name: "pinkAccentStatus")
  public static let primaryGreen = ColorAsset(name: "primaryGreen")
  public static let purpleAccent = ColorAsset(name: "purpleAccent")
  public static let purpleAccentStatus = ColorAsset(name: "purpleAccentStatus")
  public static let redAccent = ColorAsset(name: "redAccent")
  public static let textGray = ColorAsset(name: "textGray")
  public static let textGreen = ColorAsset(name: "textGreen")
  public static let userAvatarBorder = ColorAsset(name: "userAvatarBorder")
  public static let yellowAccent = ColorAsset(name: "yellowAccent")
  public static let yellowBackground = ColorAsset(name: "yellowBackground")
  public static let defaultProfilePhoto = ImageAsset(name: "defaultProfilePhoto")
  public static let defaultUserProfilePhoto = ImageAsset(name: "defaultUserProfilePhoto")
  public static let googleIcon = ImageAsset(name: "google_icon")
  public static let googleIcon21 = ImageAsset(name: "google_icon2 1")
  public static let miniGamePlantLarge = ImageAsset(name: "miniGamePlantLarge")
  public static let miniGamePlantMedium = ImageAsset(name: "miniGamePlantMedium")
  public static let miniGamePlantSmall = ImageAsset(name: "miniGamePlantSmall")
  public static let onboardingPets = ImageAsset(name: "onboardingPets")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  public func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  public func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

public extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
