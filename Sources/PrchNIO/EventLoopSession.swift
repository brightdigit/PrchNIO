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
}
