import AsyncHTTPClient
import Foundation
import NIOCore
import NIOHTTP1
import Prch

extension HTTPClient: EventLoopSession {
  public func nextEventLoop() -> EventLoop {
    eventLoopGroup.next()
  }

  public func beginRequest(
    _ request: HTTPClient.Request
  ) -> EventLoopFuture<Prch.Response> {
    execute(request: request).map { $0 as Prch.Response }
  }

  public func createRequest<ResponseType>(
    _ request: APIRequest<ResponseType>,
    withBaseURL baseURL: URL,
    andHeaders headers: [String: String]
  ) throws -> HTTPClient.Request where ResponseType: APIResponseValue {
    guard var componenets = URLComponents(
      url: baseURL.appendingPathComponent(request.path),
      resolvingAgainstBaseURL: false
    ) else {
      throw APIClientError.badURL(baseURL, request.path)
    }

    // filter out parameters with empty string value
    var queryItems = [URLQueryItem]()
    for (key, value) in request.queryParameters {
      if !String(describing: value).isEmpty {
        queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
      }
    }
    componenets.queryItems = queryItems

    guard let url = componenets.url else {
      throw APIClientError.urlComponents(componenets)
    }

    let method = HTTPMethod(rawValue: request.service.method)

    let headerDict = request.headers.merging(
      headers, uniquingKeysWith: { requestHeaderKey, _ in
        requestHeaderKey
      }
    )

    let headers = HTTPHeaders(Array(headerDict))

    let body: Body?
    if let encodeBody = request.encodeBody {
      body = try Body.data(encodeBody(JSONEncoder()))
    } else {
      body = nil
    }
    return try HTTPClient.Request(url: url, method: method, headers: headers, body: body)
  }
}
