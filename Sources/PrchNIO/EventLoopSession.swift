import AsyncHTTPClient
import Foundation
import NIOCore
import Prch

public protocol EventLoopSession: Session {
  func beginRequest(_ request: RequestType) -> EventLoopFuture<ResponseComponents>
  func nextEventLoop() -> EventLoop
}

public extension EventLoopSession {
  func beginRequest(
    _ request: RequestType,
    _ completion: @escaping ((Result<ResponseComponents, ClientError>) -> Void)
  ) -> Task {
    beginRequest(request).always { result in
      let newResult: Result<ResponseComponents, ClientError>
      switch result {
      case let .failure(error):
        newResult = .failure(.networkError(error))

      case let .success(response):
        newResult = .success(response)
      }
      completion(newResult)
    }
  }

  #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    func request(_ request: RequestType) async throws -> ResponseComponents {
      try await beginRequest(request).get()
    }
  #endif
}
