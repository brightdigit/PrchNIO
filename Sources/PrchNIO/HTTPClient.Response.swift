import AsyncHTTPClient
import Foundation
import Prch

extension HTTPClient.Response: ResponseComponents {
  public var statusCode: Int? {
    Int(status.code)
  }

  public var data: Data? {
    body.map {
      Data(buffer: $0)
    }
  }
}
