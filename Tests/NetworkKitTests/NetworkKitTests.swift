import XCTest
import Alamofire
@testable import NetworkKit

final class NetworkKitTests: XCTestCase {
  var session: Session!
  var service: NetworkService!
  
  override func setUp() {
    super.setUp()
    let configuration = URLSessionConfiguration.af.default
    configuration.protocolClasses = [MockURLProtocol.self]
    session = Session(configuration: configuration)
    service = NetworkService(session: session)
  }
  
  override func tearDown() {
    session = nil
    service = nil
    MockURLProtocol.stubResponseData = nil
    MockURLProtocol.stubError = nil
    super.tearDown()
  }
  
  func testRequestSuccess() async throws {
    // Given
    let mockPost = Post(id: 1, title: "Test", body: "Body", userId: 1)
    let data = try JSONEncoder().encode(mockPost)
    MockURLProtocol.stubResponseData = data
    MockURLProtocol.stubResponse = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    // When
    let result: Post = try await service.request("https://test.com")
    
    // Then
    XCTAssertEqual(result.title, "Test")
  }
  
  func testRequestFailure() async {
    // Given
    MockURLProtocol.stubResponse = HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)
    
    // When/Then
    do {
      let _: Post = try await service.request("https://test.com")
      XCTFail("Should have thrown an error")
    } catch let error as NetworkError {
      if case .serverError(let statusCode, _) = error {
        XCTAssertEqual(statusCode, 404)
      } else {
        XCTFail("Expected serverError, got \(error)")
      }
    } catch {
      XCTFail("Unexpected error type: \(error)")
    }
  }
}

// Mock URLProtocol
final class MockURLProtocol: URLProtocol {
  static var stubResponseData: Data?
  static var stubResponse: URLResponse?
  static var stubError: Error?
  
  override class func canInit(with request: URLRequest) -> Bool { true }
  override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
  
  override func startLoading() {
    if let error = MockURLProtocol.stubError {
      client?.urlProtocol(self, didFailWithError: error)
    } else {
      if let response = MockURLProtocol.stubResponse {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      }
      if let data = MockURLProtocol.stubResponseData {
        client?.urlProtocol(self, didLoad: data)
      }
      client?.urlProtocolDidFinishLoading(self)
    }
  }
  
  override func stopLoading() {}
}

// Minimal Post model for tests if not accessible
struct Post: Codable {
  let id: Int
  let title: String
  let body: String
  let userId: Int
}
