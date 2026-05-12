//
// Copyright (c) 2026 Coderkube Technologies - NetworkKit. All rights reserved.
//

import Foundation
import Alamofire

/// A concrete implementation of `NetworkProtocol` using Alamofire.
/// Provides high-level methods for making network requests, uploading files, and downloading data.
public final class NetworkService: NetworkProtocol {
  private let session: Session
  
  /// Initializes a new instance of `NetworkService`.
  /// - Parameter session: The Alamofire `Session` to use for requests. Defaults to `.default`.
  public init(session: Session = .default) {
    self.session = session
  }
  
  /// Performs a network request and decodes the response into a specified type.
  /// - Parameters:
  ///   - url: The endpoint URL.
  ///   - method: The HTTP method (e.g., .get, .post). Defaults to `.get`.
  ///   - parameters: The parameters to send with the request. Defaults to `nil`.
  ///   - encoding: The parameter encoding. Defaults to `URLEncoding.default`.
  ///   - headers: Optional HTTP headers.
  ///   - interceptor: Optional request interceptor (e.g., for authentication or retries).
  /// - Returns: A decoded object of type `T`.
  /// - Throws: A `NetworkError` if the request fails or decoding fails.
  public func request<T: Decodable & Sendable>(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil,
    interceptor: RequestInterceptor? = nil
  ) async throws -> T {
    return try await withCheckedThrowingContinuation { continuation in
      session.request(
        url,
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers,
        interceptor: interceptor
      )
      .validate() // Validates status code is in 200...299 range
      .responseDecodable(of: T.self) { response in
        self.handleResponse(response, continuation: continuation)
      }
    }
  }
  
  /// Performs a multipart/form-data upload request.
  /// - Parameters:
  ///   - url: The endpoint URL.
  ///   - method: The HTTP method (usually .post or .put).
  ///   - multipartFormData: A closure to construct the multipart form data.
  ///   - headers: Optional HTTP headers.
  ///   - interceptor: Optional request interceptor.
  ///   - onProgress: Optional progress callback receiving values between 0.0 and 1.0.
  /// - Returns: A decoded object of type `T`.
  /// - Throws: A `NetworkError` if the upload fails.
  public func upload<T: Decodable & Sendable>(
    _ url: URLConvertible,
    method: HTTPMethod,
    multipartFormData: @escaping (MultipartFormData) -> Void,
    headers: HTTPHeaders?,
    interceptor: RequestInterceptor?,
    onProgress: (@Sendable (Double) -> Void)?
  ) async throws -> T {
    return try await withCheckedThrowingContinuation { continuation in
      session.upload(
        multipartFormData: multipartFormData,
        to: url,
        method: method,
        headers: headers,
        interceptor: interceptor
      )
      .uploadProgress { progress in
        onProgress?(progress.fractionCompleted)
      }
      .validate()
      .responseDecodable(of: T.self) { response in
        self.handleResponse(response, continuation: continuation)
      }
    }
  }
  
  /// Downloads a file from the specified URL.
  /// - Parameters:
  ///   - url: The source URL.
  ///   - method: The HTTP method.
  ///   - parameters: Optional parameters.
  ///   - encoding: Parameter encoding.
  ///   - headers: Optional HTTP headers.
  ///   - interceptor: Optional request interceptor.
  ///   - destination: A closure determining where the file should be saved.
  ///   - onProgress: Optional progress callback.
  /// - Returns: The local URL where the file was saved.
  /// - Throws: A `NetworkError` if the download fails.
  public func download(
    _ url: URLConvertible,
    method: HTTPMethod,
    parameters: Parameters?,
    encoding: ParameterEncoding,
    headers: HTTPHeaders?,
    interceptor: RequestInterceptor?,
    to destination: DownloadRequest.Destination?,
    onProgress: (@Sendable (Double) -> Void)?
  ) async throws -> URL {
    return try await withCheckedThrowingContinuation { continuation in
      session.download(
        url,
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers,
        interceptor: interceptor,
        to: destination
      )
      .downloadProgress { progress in
        onProgress?(progress.fractionCompleted)
      }
      .validate()
      .response { response in
        switch response.result {
        case .success(let url):
          if let url = url {
            continuation.resume(returning: url)
          } else {
            continuation.resume(throwing: NetworkError.custom("Download succeeded but URL is nil"))
          }
        case .failure(let error):
          continuation.resume(throwing: self.mapError(error, response: response.response, data: nil))
        }
      }
    }
  }
  
  /// Internal handler for processing Alamofire data responses.
  private func handleResponse<T: Decodable & Sendable>(
    _ response: DataResponse<T, AFError>,
    continuation: CheckedContinuation<T, Error>
  ) {
    let method = response.request?.httpMethod ?? "UNKNOWN"
    let url = response.request?.url?.absoluteString ?? "UNKNOWN"
    let statusCode = response.response?.statusCode
    
    // Log to package's internal logger for the Tester UI
    Task { @MainActor in
      NetworkLogger.shared.log("[\(method)] \(url) -> \(statusCode ?? 0)", type: statusCode ?? 0 < 400 ? .response : .error)
    }
    
    // Print for console debugging
    print("📢 [\(method)] \(url) -> \(statusCode ?? 0)")
    
    switch response.result {
    case .success(let value):
      continuation.resume(returning: value)
    case .failure(let error):
      continuation.resume(throwing: self.mapError(error, response: response.response, data: response.data))
    }
  }
  
  /// Maps Alamofire/URLSession errors into the package's unified `NetworkError` type.
  private func mapError(_ error: AFError, response: HTTPURLResponse?, data: Data?) -> NetworkError {
    if let statusCode = response?.statusCode {
      return .serverError(statusCode: statusCode, data: data)
    } else if error.isSessionTaskError {
      let urlError = error.underlyingError as? URLError
      if urlError?.code == .notConnectedToInternet {
        return .noInternetConnection
      } else if urlError?.code == .timedOut {
        return .timeout
      }
    } else if error.isResponseSerializationError {
      return .decodingFailed
    } else if error.isInvalidURLError {
      return .invalidURL
    }
    return .alamofireError(error)
  }
}
