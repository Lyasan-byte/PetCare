// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum ActivitiesHistory {
    /// History
    public static let title = L10n.tr("Localizable", "activitiesHistory.title", fallback: "History")
  }
  public enum Auth {
    /// OR
    public static let or = L10n.tr("Localizable", "auth.or", fallback: "OR")
    public enum ConfirmPassword {
      /// ••••••••
      public static let placeholder = L10n.tr("Localizable", "auth.confirm_password.placeholder", fallback: "••••••••")
      /// CONFIRM PASSWORD
      public static let title = L10n.tr("Localizable", "auth.confirm_password.title", fallback: "CONFIRM PASSWORD")
    }
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
    public enum RegistrationCompletion {
      /// Finish Registration
      public static let button = L10n.tr("Localizable", "auth.registration_completion.button", fallback: "Finish Registration")
      /// Let's finish setting up your account!
      public static let subtitle = L10n.tr("Localizable", "auth.registration_completion.subtitle", fallback: "Let's finish setting up your account!")
      /// Welcome!
      public static let title = L10n.tr("Localizable", "auth.registration_completion.title", fallback: "Welcome!")
    }
    public enum Validation {
      /// Please fill in all fields
      public static let fillAllFields = L10n.tr("Localizable", "auth.validation.fill_all_fields", fallback: "Please fill in all fields")
      /// Password must contain at least 6 characters
      public static let passwordTooShort = L10n.tr("Localizable", "auth.validation.password_too_short", fallback: "Password must contain at least 6 characters")
      /// Passwords do not match
      public static let passwordsDoNotMatch = L10n.tr("Localizable", "auth.validation.passwords_do_not_match", fallback: "Passwords do not match")
    }
  }
  public enum Common {
    /// Cancel
    public static let cancel = L10n.tr("Localizable", "common.cancel", fallback: "Cancel")
    /// Delete
    public static let delete = L10n.tr("Localizable", "common.delete", fallback: "Delete")
    /// Error
    public static let error = L10n.tr("Localizable", "common.error", fallback: "Error")
    /// Help
    public static let help = L10n.tr("Localizable", "common.help", fallback: "Help")
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
  public enum Mini {
    public enum Game {
      public enum Empty {
        /// Add a pet in My Pets to use it as a runner.
        public static let subtitle = L10n.tr("Localizable", "mini.game.empty.subtitle", fallback: "Add a pet in My Pets to use it as a runner.")
        /// No pets for runner selection
        public static let title = L10n.tr("Localizable", "mini.game.empty.title", fallback: "No pets for runner selection")
      }
      public enum Field {
        /// Best
        public static let bestScore = L10n.tr("Localizable", "mini.game.field.best_score", fallback: "Best")
        /// Game Over
        public static let gameOver = L10n.tr("Localizable", "mini.game.field.game_over", fallback: "Game Over")
        /// Score
        public static let lastScore = L10n.tr("Localizable", "mini.game.field.last_score", fallback: "Score")
        /// Choose a pet to start
        public static let noPet = L10n.tr("Localizable", "mini.game.field.no_pet", fallback: "Choose a pet to start")
        /// Gameplay will be connected here next.
        public static let previewHint = L10n.tr("Localizable", "mini.game.field.preview_hint", fallback: "Gameplay will be connected here next.")
        /// Restart
        public static let restart = L10n.tr("Localizable", "mini.game.field.restart", fallback: "Restart")
        /// Run preview in progress
        public static let running = L10n.tr("Localizable", "mini.game.field.running", fallback: "Run preview in progress")
        /// Tap the field to start
        public static let startHint = L10n.tr("Localizable", "mini.game.field.start_hint", fallback: "Tap the field to start")
        /// TAP TO JUMP
        public static let tapToJump = L10n.tr("Localizable", "mini.game.field.tap_to_jump", fallback: "TAP TO JUMP")
      }
      public enum Runner {
        /// SELECT YOUR RUNNER
        public static let select = L10n.tr("Localizable", "mini.game.runner.select", fallback: "SELECT YOUR RUNNER")
      }
      public enum Scoreboard {
        /// HIGH
        public static let high = L10n.tr("Localizable", "mini.game.scoreboard.high", fallback: "HIGH")
        /// Score
        public static let score = L10n.tr("Localizable", "mini.game.scoreboard.score", fallback: "Score")
      }
      public enum Screen {
        /// Pet Runner
        public static let title = L10n.tr("Localizable", "mini.game.screen.title", fallback: "Pet Runner")
      }
    }
  }
  public enum Notifications {
    public enum Grooming {
      /// It's time to plan %1$@'s grooming.
      public static func body(_ p1: Any) -> String {
        return L10n.tr("Localizable", "notifications.grooming.body", String(describing: p1), fallback: "It's time to plan %1$@'s grooming.")
      }
      /// Grooming Reminder
      public static let title = L10n.tr("Localizable", "notifications.grooming.title", fallback: "Grooming Reminder")
    }
    public enum Vet {
      /// It's time to plan %1$@'s vet visit.
      public static func body(_ p1: Any) -> String {
        return L10n.tr("Localizable", "notifications.vet.body", String(describing: p1), fallback: "It's time to plan %1$@'s vet visit.")
      }
      /// Vet Reminder
      public static let title = L10n.tr("Localizable", "notifications.vet.title", fallback: "Vet Reminder")
    }
    public enum Walk {
      /// It's time for %1$@'s walk.
      public static func body(_ p1: Any) -> String {
        return L10n.tr("Localizable", "notifications.walk.body", String(describing: p1), fallback: "It's time for %1$@'s walk.")
      }
      /// Walk Reminder
      public static let title = L10n.tr("Localizable", "notifications.walk.title", fallback: "Walk Reminder")
    }
  }

  public enum OnboardingCare {
    /// Log walks, grooming, and vet visits. Stay on top of reminders and follow your pet's progress in analytics.
    public static let description = L10n.tr("Localizable", "onboardingCare.description", fallback: "Log walks, grooming, and vet visits. Stay on top of reminders and follow your pet's progress in analytics.")
    public enum Card {
      public enum Analytics {
        /// Smart Stats
        public static let title = L10n.tr("Localizable", "onboardingCare.card.analytics.title", fallback: "Smart Stats")
      }
      public enum Grooming {
        /// Grooming Plans
        public static let title = L10n.tr("Localizable", "onboardingCare.card.grooming.title", fallback: "Grooming Plans")
      }
      public enum Vet {
        /// Vet Visits
        public static let title = L10n.tr("Localizable", "onboardingCare.card.vet.title", fallback: "Vet Visits")
      }
      public enum Walks {
        /// Daily Walks
        public static let title = L10n.tr("Localizable", "onboardingCare.card.walks.title", fallback: "Daily Walks")
      }
    }
    public enum NextButton {
      /// Next →
      public static let title = L10n.tr("Localizable", "onboardingCare.nextButton.title", fallback: "Next →")
    }
    public enum Title {
      /// Track Daily
      public static let first = L10n.tr("Localizable", "onboardingCare.title.first", fallback: "Track Daily")
      /// Care
      public static let second = L10n.tr("Localizable", "onboardingCare.title.second", fallback: "Care")
    }
  }
  public enum OnboardingCommunity {
    /// Explore public pet profiles, share the journey, and jump into Pet Runner with your own companion.
    public static let description = L10n.tr("Localizable", "onboardingCommunity.description", fallback: "Explore public pet profiles, share the journey, and jump into Pet Runner with your own companion.")
    public enum Card {
      public enum PublicPets {
        /// Public Pets
        public static let title = L10n.tr("Localizable", "onboardingCommunity.card.publicPets.title", fallback: "Public Pets")
      }
    }
    public enum NextButton {
      /// Get Started →
      public static let title = L10n.tr("Localizable", "onboardingCommunity.nextButton.title", fallback: "Get Started →")
    }
    public enum Title {
      /// Play &
      public static let first = L10n.tr("Localizable", "onboardingCommunity.title.first", fallback: "Play &")
      /// Connect
      public static let second = L10n.tr("Localizable", "onboardingCommunity.title.second", fallback: "Connect")
    }

  public enum PetActivityCreation {
    public enum Validation {
      /// Please fill all the fields correctly
      public static let fillFieldsCorrectly = L10n.tr("Localizable", "petActivityCreation.validation.fillFieldsCorrectly", fallback: "Please fill all the fields correctly")
      /// Please select a pet
      public static let selectPet = L10n.tr("Localizable", "petActivityCreation.validation.selectPet", fallback: "Please select a pet")
      public enum Grooming {
        /// Please enter grooming cost
        public static let cost = L10n.tr("Localizable", "petActivityCreation.validation.grooming.cost", fallback: "Please enter grooming cost")
        /// Grooming cost should be greater than 0
        public static let costGreaterThanZero = L10n.tr("Localizable", "petActivityCreation.validation.grooming.costGreaterThanZero", fallback: "Grooming cost should be greater than 0")
        /// Grooming cost should be less than 1 million
        public static let costMaxLimit = L10n.tr("Localizable", "petActivityCreation.validation.grooming.costMaxLimit", fallback: "Grooming cost should be less than 1 million")
        /// Please enter grooming duration
        public static let duration = L10n.tr("Localizable", "petActivityCreation.validation.grooming.duration", fallback: "Please enter grooming duration")
        /// Grooming duration should be greater than 0
        public static let durationGreaterThanZero = L10n.tr("Localizable", "petActivityCreation.validation.grooming.durationGreaterThanZero", fallback: "Grooming duration should be greater than 0")
        /// Grooming duration should not be longer than 5 hours
        public static let durationMaxLimit = L10n.tr("Localizable", "petActivityCreation.validation.grooming.durationMaxLimit", fallback: "Grooming duration should not be longer than 5 hours")
      }
      public enum Vet {
        /// Please enter vet cost
        public static let cost = L10n.tr("Localizable", "petActivityCreation.validation.vet.cost", fallback: "Please enter vet cost")
        /// Vet cost should be greater than 0
        public static let costGreaterThanZero = L10n.tr("Localizable", "petActivityCreation.validation.vet.costGreaterThanZero", fallback: "Vet cost should be greater than 0")
        /// Vet cost should be less than 1 million
        public static let costMaxLimit = L10n.tr("Localizable", "petActivityCreation.validation.vet.costMaxLimit", fallback: "Vet cost should be less than 1 million")
      }
      public enum Walk {
        /// Please enter actual distance
        public static let actualDistance = L10n.tr("Localizable", "petActivityCreation.validation.walk.actualDistance", fallback: "Please enter actual distance")
        /// Actual distance should be greater than 0
        public static let actualGreaterThanZero = L10n.tr("Localizable", "petActivityCreation.validation.walk.actualGreaterThanZero", fallback: "Actual distance should be greater than 0")
        /// Actual distance should be less than 40
        public static let actualMaxLimit = L10n.tr("Localizable", "petActivityCreation.validation.walk.actualMaxLimit", fallback: "Actual distance should be less than 40")
        /// Please enter goal distance
        public static let goalDistance = L10n.tr("Localizable", "petActivityCreation.validation.walk.goalDistance", fallback: "Please enter goal distance")
        /// Goal distance should be greater than 0
        public static let goalGreaterThanZero = L10n.tr("Localizable", "petActivityCreation.validation.walk.goalGreaterThanZero", fallback: "Goal distance should be greater than 0")
        /// Goal distance should be less than 30
        public static let goalMaxLimit = L10n.tr("Localizable", "petActivityCreation.validation.walk.goalMaxLimit", fallback: "Goal distance should be less than 30")
      }
    }
  }

  public enum PetAnalytics {
    /// Analytics
    public static let title = L10n.tr("Localizable", "petAnalytics.title", fallback: "Analytics")
    public enum ChartSubtitle {
      /// Last 30 days
      public static let month = L10n.tr("Localizable", "petAnalytics.chartSubtitle.month", fallback: "Last 30 days")
      /// Last 3 months
      public static let threeMonths = L10n.tr("Localizable", "petAnalytics.chartSubtitle.threeMonths", fallback: "Last 3 months")
      /// Last 7 days
      public static let week = L10n.tr("Localizable", "petAnalytics.chartSubtitle.week", fallback: "Last 7 days")
      /// Last 12 months
      public static let year = L10n.tr("Localizable", "petAnalytics.chartSubtitle.year", fallback: "Last 12 months")
    }
    public enum EmptyState {
      /// Add your first activity to begin tracking your pet’s progress.
      public static let subtitle = L10n.tr("Localizable", "petAnalytics.emptyState.subtitle", fallback: "Add your first activity to begin tracking your pet’s progress.")
      /// No Activities
      public static let title = L10n.tr("Localizable", "petAnalytics.emptyState.title", fallback: "No Activities")
    }
    public enum GoalCompletion {
      /// %@ is %d%% through fitness targets.
      public static func description(_ p1: Any, _ p2: Int) -> String {
        return L10n.tr("Localizable", "petAnalytics.goalCompletion.description", String(describing: p1), p2, fallback: "%@ is %d%% through fitness targets.")
      }
      /// Goal Completion
      public static let title = L10n.tr("Localizable", "petAnalytics.goalCompletion.title", fallback: "Goal Completion")
      public enum ProgressRing {
        /// GOALS
        public static let subtitle = L10n.tr("Localizable", "petAnalytics.goalCompletion.progressRing.subtitle", fallback: "GOALS")
      }
    }
    public enum History {
      /// Activity History
      public static let title = L10n.tr("Localizable", "petAnalytics.history.title", fallback: "Activity History")
      /// View All
      public static let viewAll = L10n.tr("Localizable", "petAnalytics.history.viewAll", fallback: "View All")
      /// %.1f km
      public static func walkDistance(_ p1: Float) -> String {
        return L10n.tr("Localizable", "petAnalytics.history.walkDistance", p1, fallback: "%.1f km")
      }
    }
    public enum Period {
      /// Month
      public static let month = L10n.tr("Localizable", "petAnalytics.period.month", fallback: "Month")
      /// 3 Months
      public static let threeMonths = L10n.tr("Localizable", "petAnalytics.period.threeMonths", fallback: "3 Months")
      /// Week
      public static let week = L10n.tr("Localizable", "petAnalytics.period.week", fallback: "Week")
      /// Year
      public static let year = L10n.tr("Localizable", "petAnalytics.period.year", fallback: "Year")
    }
    public enum Pet {
      /// %@ • %@
      public static func breedAndAge(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "petAnalytics.pet.breedAndAge", String(describing: p1), String(describing: p2), fallback: "%@ • %@")
      }
    }
    public enum SpendingsChart {
      /// Spendings
      public static let title = L10n.tr("Localizable", "petAnalytics.spendingsChart.title", fallback: "Spendings")
    }
    public enum Stats {
      /// AVG. KM
      public static let averageKm = L10n.tr("Localizable", "petAnalytics.stats.averageKm", fallback: "AVG. KM")
      /// TOTAL SPENDINGS
      public static let totalSpendings = L10n.tr("Localizable", "petAnalytics.stats.totalSpendings", fallback: "TOTAL SPENDINGS")
      /// TOTAL WALKS
      public static let totalWalks = L10n.tr("Localizable", "petAnalytics.stats.totalWalks", fallback: "TOTAL WALKS")
    }
    public enum WalkChart {
      /// Km Count
      public static let title = L10n.tr("Localizable", "petAnalytics.walkChart.title", fallback: "Km Count")
    }
  }
  public enum PetProfile {
    public enum BirthdayBadge {
      /// Happy birthday!
      public static let text = L10n.tr("Localizable", "petProfile.birthdayBadge.text", fallback: "Happy birthday!")
    }
  }
  public enum Pets {
    public enum Activity {
      /// ACTIVITY DATE
      public static let date = L10n.tr("Localizable", "pets.activity.date", fallback: "ACTIVITY DATE")
      /// ACTIVITY NOTES
      public static let notes = L10n.tr("Localizable", "pets.activity.notes", fallback: "ACTIVITY NOTES")
      /// Save Activity
      public static let saveButton = L10n.tr("Localizable", "pets.activity.save_button", fallback: "Save Activity")
      /// SELECT PET
      public static let selectPet = L10n.tr("Localizable", "pets.activity.select_pet", fallback: "SELECT PET")
      public enum Grooming {
        /// COST
        public static let cost = L10n.tr("Localizable", "pets.activity.grooming.cost", fallback: "COST")
        /// DURATION (MIN)
        public static let duration = L10n.tr("Localizable", "pets.activity.grooming.duration", fallback: "DURATION (MIN)")
        /// PROCEDURE TYPE
        public static let procedureType = L10n.tr("Localizable", "pets.activity.grooming.procedure_type", fallback: "PROCEDURE TYPE")
        public enum Cost {
          /// 0.0
          public static let placeholder = L10n.tr("Localizable", "pets.activity.grooming.cost.placeholder", fallback: "0.0")
        }
        public enum Duration {
          /// 30
          public static let placeholder = L10n.tr("Localizable", "pets.activity.grooming.duration.placeholder", fallback: "30")
        }
      }
      public enum Reminder {
        /// Get notified for next session.
        public static let subtitle = L10n.tr("Localizable", "pets.activity.reminder.subtitle", fallback: "Get notified for next session.")
        /// Set Reminder
        public static let title = L10n.tr("Localizable", "pets.activity.reminder.title", fallback: "Set Reminder")
        public enum Daily {
          /// Receive a reminder every day at 9:00.
          public static let subtitle = L10n.tr("Localizable", "pets.activity.reminder.daily.subtitle", fallback: "Receive a reminder every day at 9:00.")
        }
        public enum Monthly {
          /// Receive a reminder every month at 9:00.
          public static let subtitle = L10n.tr("Localizable", "pets.activity.reminder.monthly.subtitle", fallback: "Receive a reminder every month at 9:00.")
        }
      }
      public enum Screen {
        /// Create Activity
        public static let title = L10n.tr("Localizable", "pets.activity.screen.title", fallback: "Create Activity")
      }
      public enum Vet {
        /// COST
        public static let cost = L10n.tr("Localizable", "pets.activity.vet.cost", fallback: "COST")
        /// PROCEDURE TYPE
        public static let procedureType = L10n.tr("Localizable", "pets.activity.vet.procedure_type", fallback: "PROCEDURE TYPE")
        public enum Cost {
          /// 0.0
          public static let placeholder = L10n.tr("Localizable", "pets.activity.vet.cost.placeholder", fallback: "0.0")
        }
      }
      public enum Walk {
        /// ACTUAL
        public static let actual = L10n.tr("Localizable", "pets.activity.walk.actual", fallback: "ACTUAL")
        /// KM GOAL
        public static let kmGoal = L10n.tr("Localizable", "pets.activity.walk.km_goal", fallback: "KM GOAL")
        public enum Actual {
          /// 3.7
          public static let placeholder = L10n.tr("Localizable", "pets.activity.walk.actual.placeholder", fallback: "3.7")
        }
        public enum KmGoal {
          /// 5.1
          public static let placeholder = L10n.tr("Localizable", "pets.activity.walk.km_goal.placeholder", fallback: "5.1")
        }
      }
    }
    public enum Age {
      public enum Day {
        /// %d days
        public static func few(_ p1: Int) -> String {
          return L10n.tr("Localizable", "pets.age.day.few", p1, fallback: "%d days")
        }
        /// %d days
        public static func many(_ p1: Int) -> String {
          return L10n.tr("Localizable", "pets.age.day.many", p1, fallback: "%d days")
        }
        /// %d day
        public static func one(_ p1: Int) -> String {
          return L10n.tr("Localizable", "pets.age.day.one", p1, fallback: "%d day")
        }
      }
      public enum Month {
        /// %d months
        public static func few(_ p1: Int) -> String {
          return L10n.tr("Localizable", "pets.age.month.few", p1, fallback: "%d months")
        }
        /// %d months
        public static func many(_ p1: Int) -> String {
          return L10n.tr("Localizable", "pets.age.month.many", p1, fallback: "%d months")
        }
        /// %d month
        public static func one(_ p1: Int) -> String {
          return L10n.tr("Localizable", "pets.age.month.one", p1, fallback: "%d month")
        }
      }
      public enum Year {
        /// %d years
        public static func few(_ p1: Int) -> String {
          return L10n.tr("Localizable", "pets.age.year.few", p1, fallback: "%d years")
        }
        /// %d years
        public static func many(_ p1: Int) -> String {
          return L10n.tr("Localizable", "pets.age.year.many", p1, fallback: "%d years")
        }
        /// %d year
        public static func one(_ p1: Int) -> String {
          return L10n.tr("Localizable", "pets.age.year.one", p1, fallback: "%d year")
        }
      }
    }
    public enum Facts {
      /// BREED INFORMATION
      public static let breedInformation = L10n.tr("Localizable", "pets.facts.breed_information", fallback: "BREED INFORMATION")
      /// Close
      public static let closeButton = L10n.tr("Localizable", "pets.facts.close_button", fallback: "Close")
      /// DIET
      public static let diet = L10n.tr("Localizable", "pets.facts.diet", fallback: "DIET")
      /// No information was found for this breed
      public static let emptyState = L10n.tr("Localizable", "pets.facts.empty_state", fallback: "No information was found for this breed")
      /// GROUP
      public static let group = L10n.tr("Localizable", "pets.facts.group", fallback: "GROUP")
      /// LIFESPAN
      public static let lifespan = L10n.tr("Localizable", "pets.facts.lifespan", fallback: "LIFESPAN")
      /// LOCATIONS
      public static let locations = L10n.tr("Localizable", "pets.facts.locations", fallback: "LOCATIONS")
      /// SKIN TYPE
      public static let skinType = L10n.tr("Localizable", "pets.facts.skin_type", fallback: "SKIN TYPE")
      /// WEIGHT
      public static let weight = L10n.tr("Localizable", "pets.facts.weight", fallback: "WEIGHT")
    }
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
      public enum DeleteConfirmation {
        /// Are you sure you want to delete this pet?
        public static let message = L10n.tr("Localizable", "pets.form.delete_confirmation.message", fallback: "Are you sure you want to delete this pet?")
        /// Delete
        public static let title = L10n.tr("Localizable", "pets.form.delete_confirmation.title", fallback: "Delete")
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
      public enum Navigation {
        /// Create Pet
        public static let create = L10n.tr("Localizable", "pets.form.navigation.create", fallback: "Create Pet")
        /// Edit Profile
        public static let edit = L10n.tr("Localizable", "pets.form.navigation.edit", fallback: "Edit Profile")
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
    public enum Gender {
      /// Female
      public static let female = L10n.tr("Localizable", "pets.gender.female", fallback: "Female")
      /// Male
      public static let male = L10n.tr("Localizable", "pets.gender.male", fallback: "Male")
    }
    public enum Grooming {
      /// Bath
      public static let bath = L10n.tr("Localizable", "pets.grooming.bath", fallback: "Bath")
      /// Brushing
      public static let brushing = L10n.tr("Localizable", "pets.grooming.brushing", fallback: "Brushing")
      /// Claws
      public static let claws = L10n.tr("Localizable", "pets.grooming.claws", fallback: "Claws")
      /// Full Service
      public static let fullService = L10n.tr("Localizable", "pets.grooming.full_service", fallback: "Full Service")
      /// Haircut
      public static let haircut = L10n.tr("Localizable", "pets.grooming.haircut", fallback: "Haircut")
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
      public enum Screen {
        /// Pet Profile
        public static let title = L10n.tr("Localizable", "pets.profile.screen.title", fallback: "Pet Profile")
      }
    }
    public enum Public {
      public enum GameScore {
        /// Best mini game score
        public static let title = L10n.tr("Localizable", "pets.public.game_score.title", fallback: "Best mini game score")
        public enum Points {
          /// %d pts
          public static func few(_ p1: Int) -> String {
            return L10n.tr("Localizable", "pets.public.game_score.points.few", p1, fallback: "%d pts")
          }
          /// %d pts
          public static func many(_ p1: Int) -> String {
            return L10n.tr("Localizable", "pets.public.game_score.points.many", p1, fallback: "%d pts")
          }
          /// %d pts
          public static func one(_ p1: Int) -> String {
            return L10n.tr("Localizable", "pets.public.game_score.points.one", p1, fallback: "%d pts")
          }
        }
      }
      public enum Header {
        /// Meet the Pack
        public static let feedTitle = L10n.tr("Localizable", "pets.public.header.feed_title", fallback: "Meet the Pack")
        /// COMMUNITY FEED
        public static let subtitle = L10n.tr("Localizable", "pets.public.header.subtitle", fallback: "COMMUNITY FEED")
        /// Public Profiles
        public static let title = L10n.tr("Localizable", "pets.public.header.title", fallback: "Public Profiles")
      }
      public enum Owner {
        /// Owned by
        public static let title = L10n.tr("Localizable", "pets.public.owner.title", fallback: "Owned by")
      }
    }
    public enum Vet {
      /// Check Up
      public static let checkUp = L10n.tr("Localizable", "pets.vet.check_up", fallback: "Check Up")
      /// Dental
      public static let dental = L10n.tr("Localizable", "pets.vet.dental", fallback: "Dental")
      /// Other
      public static let other = L10n.tr("Localizable", "pets.vet.other", fallback: "Other")
      /// Surgery
      public static let surgery = L10n.tr("Localizable", "pets.vet.surgery", fallback: "Surgery")
      /// Vaccination
      public static let vaccination = L10n.tr("Localizable", "pets.vet.vaccination", fallback: "Vaccination")
    }
  }
  public enum PublicPets {
    public enum Sort {
      /// Game Score
      public static let gameScore = L10n.tr("Localizable", "publicPets.sort.gameScore", fallback: "Game Score")
      /// Name
      public static let name = L10n.tr("Localizable", "publicPets.sort.name", fallback: "Name")
    }
  }
  public enum Repository {
    public enum Error {
      /// Repository was deallocated
      public static let deallocated = L10n.tr("Localizable", "repository.error.deallocated", fallback: "Repository was deallocated")
      /// Unknown error
      public static let unknown = L10n.tr("Localizable", "repository.error.unknown", fallback: "Unknown error")
    }
  }
  public enum Settings {
    public enum Account {
      /// Delete Account
      public static let delete = L10n.tr("Localizable", "settings.account.delete", fallback: "Delete Account")
      /// Account Management
      public static let title = L10n.tr("Localizable", "settings.account.title", fallback: "Account Management")
      public enum Delete {
        /// Please sign in again before deleting your account.
        public static let reauth = L10n.tr("Localizable", "settings.account.delete.reauth", fallback: "Please sign in again before deleting your account.")
        public enum Confirmation {
          /// Your profile and pets will be removed permanently. This action cannot be undone.
          public static let message = L10n.tr("Localizable", "settings.account.delete.confirmation.message", fallback: "Your profile and pets will be removed permanently. This action cannot be undone.")
          /// Delete Account
          public static let title = L10n.tr("Localizable", "settings.account.delete.confirmation.title", fallback: "Delete Account")
        }
      }
    }
    public enum Appearance {
      /// Appearance
      public static let title = L10n.tr("Localizable", "settings.appearance.title", fallback: "Appearance")
      public enum Language {
        /// English
        public static let english = L10n.tr("Localizable", "settings.appearance.language.english", fallback: "English")
        /// Russian
        public static let russian = L10n.tr("Localizable", "settings.appearance.language.russian", fallback: "Russian")
        /// Preferred app language
        public static let subtitle = L10n.tr("Localizable", "settings.appearance.language.subtitle", fallback: "Preferred app language")
        /// Language
        public static let title = L10n.tr("Localizable", "settings.appearance.language.title", fallback: "Language")
      }
      public enum Theme {
        /// Dark
        public static let dark = L10n.tr("Localizable", "settings.appearance.theme.dark", fallback: "Dark")
        /// Light
        public static let light = L10n.tr("Localizable", "settings.appearance.theme.light", fallback: "Light")
        /// Switch between light and dark
        public static let subtitle = L10n.tr("Localizable", "settings.appearance.theme.subtitle", fallback: "Switch between light and dark")
        /// Theme
        public static let title = L10n.tr("Localizable", "settings.appearance.theme.title", fallback: "Theme")
      }
    }
    public enum Notifications {
      /// All Notifications
      public static let all = L10n.tr("Localizable", "settings.notifications.all", fallback: "All Notifications")
      /// Grooming
      public static let grooming = L10n.tr("Localizable", "settings.notifications.grooming", fallback: "Grooming")
      /// Notification Settings
      public static let title = L10n.tr("Localizable", "settings.notifications.title", fallback: "Notification Settings")
      /// Veterinarian
      public static let veterinarian = L10n.tr("Localizable", "settings.notifications.veterinarian", fallback: "Veterinarian")
      /// Walks
      public static let walk = L10n.tr("Localizable", "settings.notifications.walk", fallback: "Walks")
    }
    public enum Screen {
      /// Settings
      public static let title = L10n.tr("Localizable", "settings.screen.title", fallback: "Settings")
    }
  }
  public enum User {
    public enum Profile {
      public enum Best {
        /// Best Score
        public static let score = L10n.tr("Localizable", "user.profile.best.score", fallback: "Best Score")
      }
      public enum Edit {
        /// Save Changes
        public static let saveButton = L10n.tr("Localizable", "user.profile.edit.save_button", fallback: "Save Changes")
        public enum FirstName {
          /// Enter first name
          public static let placeholder = L10n.tr("Localizable", "user.profile.edit.first_name.placeholder", fallback: "Enter first name")
          /// First Name
          public static let title = L10n.tr("Localizable", "user.profile.edit.first_name.title", fallback: "First Name")
        }
        public enum LastName {
          /// Enter last name
          public static let placeholder = L10n.tr("Localizable", "user.profile.edit.last_name.placeholder", fallback: "Enter last name")
          /// Last Name
          public static let title = L10n.tr("Localizable", "user.profile.edit.last_name.title", fallback: "Last Name")
        }
        public enum Navigation {
          /// Edit Profile
          public static let title = L10n.tr("Localizable", "user.profile.edit.navigation.title", fallback: "Edit Profile")
        }
        public enum Photo {
          /// Tap to update your avatar
          public static let subtitle = L10n.tr("Localizable", "user.profile.edit.photo.subtitle", fallback: "Tap to update your avatar")
          /// Change Profile Photo
          public static let title = L10n.tr("Localizable", "user.profile.edit.photo.title", fallback: "Change Profile Photo")
        }
        public enum Validation {
          /// Enter first name
          public static let firstName = L10n.tr("Localizable", "user.profile.edit.validation.first_name", fallback: "Enter first name")
          /// Enter last name
          public static let lastName = L10n.tr("Localizable", "user.profile.edit.validation.last_name", fallback: "Enter last name")
        }
      }
      public enum Email {
        /// No email
        public static let missing = L10n.tr("Localizable", "user.profile.email.missing", fallback: "No email")
      }
      public enum Logout {
        /// Logout
        public static let title = L10n.tr("Localizable", "user.profile.logout.title", fallback: "Logout")
        public enum Confirmation {
          /// Are you sure you want to log out of your account?
          public static let message = L10n.tr("Localizable", "user.profile.logout.confirmation.message", fallback: "Are you sure you want to log out of your account?")
          /// Logout
          public static let title = L10n.tr("Localizable", "user.profile.logout.confirmation.title", fallback: "Logout")
        }
      }
      public enum Name {
        /// Pet Lover
        public static let placeholder = L10n.tr("Localizable", "user.profile.name.placeholder", fallback: "Pet Lover")
      }
      public enum Pets {
        /// Number of Pets
        public static let count = L10n.tr("Localizable", "user.profile.pets.count", fallback: "Number of Pets")
      }
      public enum Screen {
        /// Profile
        public static let title = L10n.tr("Localizable", "user.profile.screen.title", fallback: "Profile")
      }
      public enum Settings {
        /// Settings screen is coming soon.
        public static let placeholder = L10n.tr("Localizable", "user.profile.settings.placeholder", fallback: "Settings screen is coming soon.")
        /// Notifications, Appearance & Account Management
        public static let subtitle = L10n.tr("Localizable", "user.profile.settings.subtitle", fallback: "Notifications, Appearance & Account Management")
        /// Settings
        public static let title = L10n.tr("Localizable", "user.profile.settings.title", fallback: "Settings")
      }
    }
  }
  public enum WelcomeOnboarding {
    /// The ultimate sanctuary for your furry friends. Track care, health and more.
    public static let description = L10n.tr("Localizable", "welcomeOnboarding.description", fallback: "The ultimate sanctuary for your furry friends. Track care, health and more.")
    public enum Header {
      /// Pet Care
      public static let text = L10n.tr("Localizable", "welcomeOnboarding.header.text", fallback: "Pet Care")
    }
    public enum ImageBadge {
      /// KINDRED SPIRIT
      public static let text = L10n.tr("Localizable", "welcomeOnboarding.imageBadge.text", fallback: "KINDRED SPIRIT")
    }
    public enum NextButton {
      /// Next →
      public static let title = L10n.tr("Localizable", "welcomeOnboarding.nextButton.title", fallback: "Next →")
    }
    public enum SkipButton {
      /// Skip
      public static let title = L10n.tr("Localizable", "welcomeOnboarding.skipButton.title", fallback: "Skip")
    }
    public enum Title {
      /// Welcome to
      public static let first = L10n.tr("Localizable", "welcomeOnboarding.title.first", fallback: "Welcome to")
      /// Pet Care
      public static let second = L10n.tr("Localizable", "welcomeOnboarding.title.second", fallback: "Pet Care")
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
