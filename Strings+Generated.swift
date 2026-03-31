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
  public enum Pets {
    public enum Form {
      /// Delete Profile
      public static let deleteButton = L10n.tr("Localizable", "pets.form.delete_button", fallback: "Delete Profile")
      /// Save Changes
      public static let saveButton = L10n.tr("Localizable", "pets.form.save_button", fallback: "Save Changes")
      public enum BirthDate {
        /// DATE OF BIRTH
        public static let title = L10n.tr("Localizable", "pets.form.birth_date.title", fallback: "DATE OF BIRTH")
      }
      public enum Breed {
        /// Golden Retriever
        public static let placeholder = L10n.tr("Localizable", "pets.form.breed.placeholder", fallback: "Golden Retriever")
        /// BREED
        public static let title = L10n.tr("Localizable", "pets.form.breed.title", fallback: "BREED")
      }
      public enum Gender {
        /// GENDER
        public static let title = L10n.tr("Localizable", "pets.form.gender.title", fallback: "GENDER")
      }
      public enum IconPicker {
        /// SELECT ICON
        public static let title = L10n.tr("Localizable", "pets.form.icon_picker.title", fallback: "SELECT ICON")
      }
      public enum Name {
        /// Cooper
        public static let placeholder = L10n.tr("Localizable", "pets.form.name.placeholder", fallback: "Cooper")
        /// PET NAME
        public static let title = L10n.tr("Localizable", "pets.form.name.title", fallback: "PET NAME")
      }
      public enum Note {
        /// FEATURES / NOTES
        public static let title = L10n.tr("Localizable", "pets.form.note.title", fallback: "FEATURES / NOTES")
      }
      public enum PhotoPicker {
        /// Change Profile Photo
        public static let title = L10n.tr("Localizable", "pets.form.photo_picker.title", fallback: "Change Profile Photo")
      }
      public enum PublicProfile {
        /// Visible to local pet owners.
        public static let subtitle = L10n.tr("Localizable", "pets.form.public_profile.subtitle", fallback: "Visible to local pet owners.")
        /// Public Profile
        public static let title = L10n.tr("Localizable", "pets.form.public_profile.title", fallback: "Public Profile")
      }
      public enum Validation {
        /// Please check the form fields.
        public static let checkFormFields = L10n.tr("Localizable", "pets.form.validation.check_form_fields", fallback: "Please check the form fields.")
        /// Enter breed
        public static let enterBreed = L10n.tr("Localizable", "pets.form.validation.enter_breed", fallback: "Enter breed")
        /// Enter pet name
        public static let enterPetName = L10n.tr("Localizable", "pets.form.validation.enter_pet_name", fallback: "Enter pet name")
        /// Enter weight
        public static let enterWeight = L10n.tr("Localizable", "pets.form.validation.enter_weight", fallback: "Enter weight")
        /// Weight must be greater than 0
        public static let weightGreaterThanZero = L10n.tr("Localizable", "pets.form.validation.weight_greater_than_zero", fallback: "Weight must be greater than 0")
      }
      public enum Weight {
        /// 28.5
        public static let placeholder = L10n.tr("Localizable", "pets.form.weight.placeholder", fallback: "28.5")
        /// WEIGHT (KG)
        public static let title = L10n.tr("Localizable", "pets.form.weight.title", fallback: "WEIGHT (KG)")
      }
    }
    public enum Main {
      /// Your Family
      public static let familyTitle = L10n.tr("Localizable", "pets.main.family_title", fallback: "Your Family")
      /// My Pets
      public static let title = L10n.tr("Localizable", "pets.main.title", fallback: "My Pets")
      public enum EmptyState {
        /// Tap the plus button to add your first friend.
        public static let subtitle = L10n.tr("Localizable", "pets.main.empty_state.subtitle", fallback: "Tap the plus button to add your first friend.")
        /// No Pets
        public static let title = L10n.tr("Localizable", "pets.main.empty_state.title", fallback: "No Pets")
      }
      public enum QuickActions {
        /// Grooming
        public static let grooming = L10n.tr("Localizable", "pets.main.quick_actions.grooming", fallback: "Grooming")
        /// CREATE ACTIVITY
        public static let subtitle = L10n.tr("Localizable", "pets.main.quick_actions.subtitle", fallback: "CREATE ACTIVITY")
        /// Quick Actions
        public static let title = L10n.tr("Localizable", "pets.main.quick_actions.title", fallback: "Quick Actions")
        /// Vet
        public static let vet = L10n.tr("Localizable", "pets.main.quick_actions.vet", fallback: "Vet")
        /// Walk
        public static let walk = L10n.tr("Localizable", "pets.main.quick_actions.walk", fallback: "Walk")
      }
      public enum Tip {
        /// Movement is medicine! Daily walks and playtime prevent boredom, reduce destructive behavior, and keep your pet’s body and mind sharp.
        public static let defaultText = L10n.tr("Localizable", "pets.main.tip.default_text", fallback: "Movement is medicine! Daily walks and playtime prevent boredom, reduce destructive behavior, and keep your pet’s body and mind sharp.")
        /// Pet Health Tip
        public static let title = L10n.tr("Localizable", "pets.main.tip.title", fallback: "Pet Health Tip")
      }
    }
    public enum Profile {
      /// Age
      public static let age = L10n.tr("Localizable", "pets.profile.age", fallback: "Age")
      /// Analytics
      public static let analyticsButton = L10n.tr("Localizable", "pets.profile.analytics_button", fallback: "Analytics")
      /// Create Activity
      public static let createActivityButton = L10n.tr("Localizable", "pets.profile.create_activity_button", fallback: "Create Activity")
      /// Edit Profile
      public static let editButton = L10n.tr("Localizable", "pets.profile.edit_button", fallback: "Edit Profile")
      /// Gender
      public static let gender = L10n.tr("Localizable", "pets.profile.gender", fallback: "Gender")
      /// FEATURES / NOTES
      public static let noteTitle = L10n.tr("Localizable", "pets.profile.note_title", fallback: "FEATURES / NOTES")
      /// Weight
      public static let weight = L10n.tr("Localizable", "pets.profile.weight", fallback: "Weight")
      /// kg
      public static let weightUnitKg = L10n.tr("Localizable", "pets.profile.weight_unit_kg", fallback: "kg")
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
