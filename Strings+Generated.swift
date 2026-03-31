// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum Auth {
    /// OR
    public static let or = L10n.tr("Localizable", "auth.or", fallback: "OR")
    public enum Email {
      /// hello@petcare.com
      public static let placeholder = L10n.tr("Localizable", "auth.email.placeholder", fallback: "hello@petcare.com")
      /// EMAIL
      public static let title = L10n.tr("Localizable", "auth.email.title", fallback: "EMAIL")
    }
    public enum Google {
      /// Continue with Google
      public static let button = L10n.tr("Localizable", "auth.google.button", fallback: "Continue with Google")
    }
    public enum Login {
      /// Login
      public static let button = L10n.tr("Localizable", "auth.login.button", fallback: "Login")
      /// Welcome back!
      public static let subtitle = L10n.tr("Localizable", "auth.login.subtitle", fallback: "Welcome back!")
      /// Register
      public static let switchAction = L10n.tr("Localizable", "auth.login.switch_action", fallback: "Register")
      /// Don't have an account?
      public static let switchPrefix = L10n.tr("Localizable", "auth.login.switch_prefix", fallback: "Don't have an account?")
      /// Don't have an account? Register
      public static let switchToRegister = L10n.tr("Localizable", "auth.login.switch_to_register", fallback: "Don't have an account? Register")
      /// Login
      public static let title = L10n.tr("Localizable", "auth.login.title", fallback: "Login")
    }
    public enum Password {
      /// ••••••••
      public static let placeholder = L10n.tr("Localizable", "auth.password.placeholder", fallback: "••••••••")
      /// PASSWORD
      public static let title = L10n.tr("Localizable", "auth.password.title", fallback: "PASSWORD")
    }
    public enum Register {
      /// Register
      public static let button = L10n.tr("Localizable", "auth.register.button", fallback: "Register")
      /// Join our family!
      public static let subtitle = L10n.tr("Localizable", "auth.register.subtitle", fallback: "Join our family!")
      /// Login
      public static let switchAction = L10n.tr("Localizable", "auth.register.switch_action", fallback: "Login")
      /// Already have an account?
      public static let switchPrefix = L10n.tr("Localizable", "auth.register.switch_prefix", fallback: "Already have an account?")
      /// Already have an account? Login
      public static let switchToLogin = L10n.tr("Localizable", "auth.register.switch_to_login", fallback: "Already have an account? Login")
      /// Register
      public static let title = L10n.tr("Localizable", "auth.register.title", fallback: "Register")
    }
    public enum Validation {
      /// Please fill in all fields
      public static let fillAllFields = L10n.tr("Localizable", "auth.validation.fill_all_fields", fallback: "Please fill in all fields")
      /// Password must contain at least 6 characters
      public static let passwordTooShort = L10n.tr("Localizable", "auth.validation.password_too_short", fallback: "Password must contain at least 6 characters")
    }
  }
  public enum Common {
    /// Error
    public static let error = L10n.tr("Localizable", "common.error", fallback: "Error")
    /// OK
    public static let ok = L10n.tr("Localizable", "common.ok", fallback: "OK")
  }
  public enum Error {
    public enum Common {
      /// Something went wrong. Please try again
      public static let tryAgain = L10n.tr("Localizable", "error.common.try_again", fallback: "Something went wrong. Please try again")
    }
    public enum Google {
      public enum ClientId {
        /// Google Sign-In configuration is missing.
        public static let missing = L10n.tr("Localizable", "error.google.clientId.missing", fallback: "Google Sign-In configuration is missing.")
      }
      public enum Token {
        /// Failed to obtain Google ID token.
        public static let missing = L10n.tr("Localizable", "error.google.token.missing", fallback: "Failed to obtain Google ID token.")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

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
