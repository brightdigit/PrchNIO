import AsyncHTTPClient
import Foundation
import Prch

extension HTTPClient.Response: Response {
  public var statusCode: Int? {
    Int(status.code)
  }

  public var data: Data? {
    body.map {
      Data(buffer: $0)
    }
  }
}
