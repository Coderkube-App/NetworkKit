//
// Copyright (c) 2026 Coderkube Technologies - NetworkKit. All rights reserved.
//

import Foundation
import Alamofire

/// A custom `RequestInterceptor` that provides automatic retry logic for failed requests.
/// It specifically targets server-side errors (status codes 500-599).
public final class RetryInterceptor: RequestInterceptor {
  private let retryLimit: Int
  private let retryDelay: TimeInterval
  
  /// Initializes a new `RetryInterceptor`.
  /// - Parameters:
  ///   - retryLimit: The maximum number of times a request can be retried. Defaults to 3.
  ///   - retryDelay: The delay (in seconds) between retry attempts. Defaults to 1.0.
  public init(retryLimit: Int = 3, retryDelay: TimeInterval = 1.0) {
    self.retryLimit = retryLimit
    self.retryDelay = retryDelay
  }
  
  /// Determines whether a failed request should be retried based on status code and retry count.
  /// - Parameters:
  ///   - request: The failed request.
  ///   - session: The session that performed the request.
  ///   - error: The error that caused the failure.
  ///   - completion: A closure to call with the retry decision.
  public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    // Retry on server errors (500-599) if the limit hasn't been reached
    if let statusCode = request.response?.statusCode, (500...599).contains(statusCode), request.retryCount < retryLimit {
      completion(.retryWithDelay(retryDelay))
    } else {
      completion(.doNotRetry)
    }
  }
}
