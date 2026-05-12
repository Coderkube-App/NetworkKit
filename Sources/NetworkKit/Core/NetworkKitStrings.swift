//
// Copyright (c) 2026 Coderkube Technologies - NetworkKit. All rights reserved.
//

import Foundation

/// A centralized registry for all localized strings used within `NetworkKit` and the `NetworkKitTester` application.
/// Strings are retrieved from the package's string catalog (`Localizable.xcstrings`) using `Bundle.module`.
public enum NetworkKitStrings {
  private static let bundle = Bundle.module
  
  /// Standard network-related error messages.
  public enum Error {
    public static let invalidURL = NSLocalizedString("error_invalid_url", bundle: bundle, comment: "")
    /// Returns a localized server error message including the status code.
    public static func serverError(code: Int) -> String {
      String(format: NSLocalizedString("error_server_error", bundle: bundle, comment: ""), code)
    }
    public static let decodingFailed = NSLocalizedString("error_decoding_failed", bundle: bundle, comment: "")
    public static let noInternet = NSLocalizedString("error_no_internet", bundle: bundle, comment: "")
    public static let timeout = NSLocalizedString("error_timeout", bundle: bundle, comment: "")
  }
  
  /// Strings for the Main Dashboard UI.
  public enum Dashboard {
    public static let crudOps = NSLocalizedString("dashboard_crud_ops", bundle: bundle, comment: "")
    public static let auth = NSLocalizedString("dashboard_auth", bundle: bundle, comment: "")
    public static let upload = NSLocalizedString("dashboard_upload", bundle: bundle, comment: "")
    public static let media = NSLocalizedString("dashboard_media", bundle: bundle, comment: "")
    public static let playground = NSLocalizedString("dashboard_playground", bundle: bundle, comment: "")
    public static let retryTest = NSLocalizedString("dashboard_retry_test", bundle: bundle, comment: "")
    public static let errorTest = NSLocalizedString("dashboard_error_test", bundle: bundle, comment: "")
    public static let appTitle = NSLocalizedString("app_title", bundle: bundle, comment: "")
  }
  
  /// Strings for the CRUD Operations module.
  public enum CRUD {
    public static let createPostSection = NSLocalizedString("crud_create_post_section", bundle: bundle, comment: "")
    public static let titlePlaceholder = NSLocalizedString("crud_title_placeholder", bundle: bundle, comment: "")
    public static let bodyPlaceholder = NSLocalizedString("crud_body_placeholder", bundle: bundle, comment: "")
    public static let createButton = NSLocalizedString("crud_create_button", bundle: bundle, comment: "")
    public static let recentPostsSection = NSLocalizedString("crud_recent_posts_section", bundle: bundle, comment: "")
    public static let navigationTitle = NSLocalizedString("crud_navigation_title", bundle: bundle, comment: "")
  }
  
  /// Strings for the Authentication module.
  public enum Auth {
    public static let loginSection = NSLocalizedString("auth_login_section", bundle: bundle, comment: "")
    public static let usernamePlaceholder = NSLocalizedString("auth_username_placeholder", bundle: bundle, comment: "")
    public static let passwordPlaceholder = NSLocalizedString("auth_password_placeholder", bundle: bundle, comment: "")
    public static let loginButton = NSLocalizedString("auth_login_button", bundle: bundle, comment: "")
    public static let tokenSection = NSLocalizedString("auth_token_section", bundle: bundle, comment: "")
    public static let accessToken = NSLocalizedString("auth_access_token", bundle: bundle, comment: "")
    public static let refreshToken = NSLocalizedString("auth_refresh_token", bundle: bundle, comment: "")
    public static let navigationTitle = NSLocalizedString("auth_navigation_title", bundle: bundle, comment: "")
  }
  
  /// Strings for the Upload module.
  public enum Upload {
    public static let selectImage = NSLocalizedString("upload_select_image", bundle: bundle, comment: "")
    public static let progress = NSLocalizedString("upload_progress", bundle: bundle, comment: "")
    public static let startButton = NSLocalizedString("upload_start_button", bundle: bundle, comment: "")
    public static let response = NSLocalizedString("upload_response", bundle: bundle, comment: "")
    public static let navigationTitle = NSLocalizedString("upload_navigation_title", bundle: bundle, comment: "")
  }
  
  /// Strings for the Media module.
  public enum Media {
    public static let imageLoading = NSLocalizedString("media_image_loading", bundle: bundle, comment: "")
    public static let videoStreaming = NSLocalizedString("media_video_streaming", bundle: bundle, comment: "")
    public static let placeholdIntegration = NSLocalizedString("media_placehold_integration", bundle: bundle, comment: "")
    public static let navigationTitle = NSLocalizedString("media_navigation_title", bundle: bundle, comment: "")
  }
  
  /// Strings for the Error Testing module.
  public enum ErrorTest {
    public static let test404 = NSLocalizedString("error_test_404", bundle: bundle, comment: "")
    public static let test500 = NSLocalizedString("error_test_500", bundle: bundle, comment: "")
    public static let testTimeout = NSLocalizedString("error_test_timeout", bundle: bundle, comment: "")
    public static let testInvalidURL = NSLocalizedString("error_test_invalid_url", bundle: bundle, comment: "")
    public static let resultSection = NSLocalizedString("error_test_result_section", bundle: bundle, comment: "")
    public static let navigationTitle = NSLocalizedString("error_test_navigation_title", bundle: bundle, comment: "")
    public static let successUnexpected = NSLocalizedString("error_test_success_unexpected", bundle: bundle, comment: "")
    /// Returns a localized message for a caught error.
    public static func caughtError(_ error: String) -> String {
      String(format: NSLocalizedString("error_test_caught_error", bundle: bundle, comment: ""), error)
    }
  }
  
  /// Strings for the Retry Testing module.
  public enum Retry {
    public static let title = NSLocalizedString("retry_test_title", bundle: bundle, comment: "")
    public static let description = NSLocalizedString("retry_test_description", bundle: bundle, comment: "")
    public static let executeButton = NSLocalizedString("retry_test_execute_button", bundle: bundle, comment: "")
    /// Returns a localized status message.
    public static func status(_ status: String) -> String {
      String(format: NSLocalizedString("retry_test_status_prefix", bundle: bundle, comment: ""), status)
    }
    public static let navigationTitle = NSLocalizedString("retry_test_navigation_title", bundle: bundle, comment: "")
    public static let started = NSLocalizedString("retry_test_started", bundle: bundle, comment: "")
    /// Returns a localized failure message after all retries.
    public static func failedAfterRetries(_ error: String) -> String {
      String(format: NSLocalizedString("retry_test_failed_after_retries", bundle: bundle, comment: ""), error)
    }
  }
  
  /// Strings for the API Playground module.
  public enum Playground {
    public static let requestDetails = NSLocalizedString("playground_request_details", bundle: bundle, comment: "")
    public static let method = NSLocalizedString("playground_method", bundle: bundle, comment: "")
    public static let url = NSLocalizedString("playground_url", bundle: bundle, comment: "")
    public static let headers = NSLocalizedString("playground_headers", bundle: bundle, comment: "")
    public static let body = NSLocalizedString("playground_body", bundle: bundle, comment: "")
    public static let triggerButton = NSLocalizedString("playground_trigger_button", bundle: bundle, comment: "")
    public static let responseSection = NSLocalizedString("playground_response_section", bundle: bundle, comment: "")
    public static let status = NSLocalizedString("playground_status", bundle: bundle, comment: "")
    public static let viewType = NSLocalizedString("playground_view_type", bundle: bundle, comment: "")
    public static let viewPretty = NSLocalizedString("playground_view_pretty", bundle: bundle, comment: "")
    public static let viewRaw = NSLocalizedString("playground_view_raw", bundle: bundle, comment: "")
    public static let navigationTitle = NSLocalizedString("playground_navigation_title", bundle: bundle, comment: "")
    public static let unableToDecode = NSLocalizedString("playground_unable_to_decode", bundle: bundle, comment: "")
  }
  
  /// Strings for the Debug/Logs module.
  public enum Debug {
    public static let navigationTitle = NSLocalizedString("debug_navigation_title", bundle: bundle, comment: "")
    public static let clearButton = NSLocalizedString("debug_clear_button", bundle: bundle, comment: "")
    public static let typeInfo = NSLocalizedString("debug_log_type_info", bundle: bundle, comment: "")
    public static let typeRequest = NSLocalizedString("debug_log_type_request", bundle: bundle, comment: "")
    public static let typeResponse = NSLocalizedString("debug_log_type_response", bundle: bundle, comment: "")
    public static let typeError = NSLocalizedString("debug_log_type_error", bundle: bundle, comment: "")
  }
  
  /// Common reusable strings.
  public enum Common {
    public static let error = NSLocalizedString("common_error", bundle: bundle, comment: "")
    public static let ok = NSLocalizedString("common_ok", bundle: bundle, comment: "")
    public static let idle = NSLocalizedString("common_idle", bundle: bundle, comment: "")
  }
}

extension Bundle {
  /// Provides easy access to the NetworkKit module bundle.
  public static var networkKit: Bundle { .module }
}
