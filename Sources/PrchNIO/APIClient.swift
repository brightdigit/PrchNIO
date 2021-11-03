import AsyncHTTPClient
import Foundation
import NIOCore
import Prch

public extension APIClient where SessionType: EventLoopSession {
  func request<ResponseType>(
    _ request: APIRequest<ResponseType>
  ) -> EventLoopFuture<ResponseType> {
    var sessionRequest: SessionType.RequestType
    do {
      sessionRequest = try session.createRequest(
        request,
        withBaseURL: api.baseURL,
        andHeaders: api.headers
      )
    } catch {
      return session
        .nextEventLoop()
        .makeFailedFuture(APIClientError.requestEncodingError(error))
    }

    return session.beginRequest(sessionRequest).flatMapThrowing { response in
      guard let httpStatus = response.statusCode else {
        throw APIClientError.invalidResponse
      }
      let data = response.data ?? Data()
      return try ResponseType(
        statusCode: httpStatus,
        data: data,
        decoder: self.api.decoder
      )
    }
  }
}
