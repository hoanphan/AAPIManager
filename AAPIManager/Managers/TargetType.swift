import Foundation
import Alamofire

/// The protocol used to define the specifications necessary for a `MoyaProvider`.
public protocol TargetType {

    /// The target's base `URL`.
    var baseURL: String { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    var contentType: String {get}

    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    
    var postData: [String: Any] {get}
    
    var getData: String {get}

    /// The headers to be used in the request.
    var headers: [String: String] { get }
    
    var isMultipartForm: Bool {get}
    
    var imageData: Data {get}
    
    func getRequestProtocol() -> RequestProtocol
}

public extension TargetType {
    
    var postData: [String: Any] {
        return [:]
    }
    
    var getData: String {
        return ""
    }
    
    var contentType: String {
        return "application/json"
    }
    
    var isMultipartForm: Bool {
        return false
    }
    
    var imageData: Data {
        return Data()
    }
    
    func getRequestProtocol() -> RequestProtocol {
        return BaseRequest(baseURL: self.baseURL,
                           function: self.path,
                           httpMethod: method,
                           contentType: self.contentType,
                           headers: self.headers,
                           postData: self.postData,
                           getParams: self.getData,
                           isMultipartForm: self.isMultipartForm,
                           imageData: self.imageData)
    }
}
