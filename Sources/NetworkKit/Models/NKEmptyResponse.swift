//
// Copyright (c) 2026 Coderkube Technologies - NetworkKit. All rights reserved.
//

import Foundation

/// A standardized model used for API responses that return no data or whose content is irrelevant.
/// This is commonly used for DELETE requests or successful POST requests that only return a 204 status.
public struct NKEmptyResponse: Decodable, Sendable {
  /// Initializes a new `NKEmptyResponse`.
  public init() {}
}
