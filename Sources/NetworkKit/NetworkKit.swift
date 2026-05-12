//
// Copyright (c) 2026 Coderkube Technologies - NetworkKit. All rights reserved.
//

import Foundation
import Alamofire

/// The main entry point for the `NetworkKit` package.
/// Provides a centralized way to configure and access networking services.
public final class NetworkKit: @unchecked Sendable {
  /// A shared instance of `NetworkKit` using the default configuration.
  public static let shared = NetworkKit()
  
  /// The underlying network service used for performing requests.
  public let service: NetworkProtocol
  
  /// Initializes a new `NetworkKit` instance with a specific service.
  /// - Parameter service: A type conforming to `NetworkProtocol`.
  public init(service: NetworkProtocol) {
    self.service = service
  }
  
  /// Initializes a new `NetworkKit` instance with a default service using the provided Alamofire session.
  /// - Parameter session: The Alamofire `Session` to use. Defaults to `.default`.
  public init(session: Session = .default) {
    self.service = NetworkService(session: session)
  }
  
  /// Initializes a new `NetworkKit` instance with a default service using a custom request interceptor.
  /// - Parameter interceptor: An optional `RequestInterceptor` for modifying requests or handling retries.
  public convenience init(interceptor: RequestInterceptor?) {
    let session = Session(interceptor: interceptor)
    self.init(session: session)
  }
}
