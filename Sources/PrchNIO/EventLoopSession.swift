import AsyncHTTPClient
import Foundation
import NIOCore
import Prch

public protocol EventLoopSession: Session {
  func beginRequest(_ request: RequestType) -> EventLoopFuture<Response>
  func nextEventLoop() -> EventLoop
}

public extension EventLoopSession {
  func beginRequest(
    _ request: RequestType,
    _ completion: @escaping ((APIResult<Response>) -> Void)
  ) -> Task {
    beginRequest(request).always { result in
      let newResult: APIResult<Response>
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
