//
//  BaseRequest.swift
//  AAPIManager
//
//  Created by HOANDHTB on 3/6/21.
//  Copyright © 2021 HOANDHTB. All rights reserved.
//

import Foundation
import Alamofire

public struct BaseRequest: RequestProtocol {
    private var postData:[String:Any] = [:]
    private var headers: [String : String] = [:]
    private var function:String = ""
    private var httpMethod:HTTPMethod = .get
    private var getParams:String = ""
    private var contentType:String = ""
    private var baseURL: String = ""
    //  For upload avatar
    private var isMultipartForm = false
    private var imageData: Data = Data()
    
    public func getId() -> String {
        return ""
    }
    
    public mutating func setBodyData(_ data: Data) {
        print(data)
    }
    
    public func getRequest() -> URLRequest {
        var urlString = "\(self.baseURL)\(function)"
        if (httpMethod == .get || httpMethod == .delete) && !getParams.isEmpty {
            urlString.append("?\(getParams)")
        }
        print("Request URL: \(urlString)")
        var urlRequest = URLRequest(url: URL(string:urlString)!)
        urlRequest.httpMethod = httpMethod.rawValue
        
        //  multipart form upload
        
        let boundary = self.generateBoundaryString()
        if isMultipartForm {
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        }else{
            urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        self.headers.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        
        if httpMethod == .post || httpMethod == .put {
            if isMultipartForm {
                if imageData.count > 0 {
                    let fullData = self.createBodyWithParameters(filePathKey: "File", imageDataKey: imageData, boundary: boundary)
                    urlRequest.setValue("\(fullData.count)", forHTTPHeaderField: "Content-Length")
                    urlRequest.httpBody = fullData
                }
            }else{
                if postData.count > 0 {
                    print("Post params: \(postData.toJsonString())")
                    urlRequest.httpBody =  postData.toJsonString().data(using: .utf8)
                }
            }
            
        }
        return urlRequest
    }
    
    public init(baseURL: String, function:String, httpMethod:HTTPMethod = .get, contentType: String = "application/json", headers:[String: String] = [:], postData:[String:Any] = [:], getParams: String = "", isMultipartForm: Bool = false, imageData: Data = Data()) {
        self.httpMethod = httpMethod
        self.contentType = contentType
        self.postData = postData
        self.baseURL = baseURL
        self.function = function
        self.headers = headers
        self.getParams = getParams
        //  For upload multi part form
        self.isMultipartForm = isMultipartForm
        self.imageData = imageData
    }
    
    
    public mutating func setData(postData:[String:Any],function:String)
    {
        self.postData = postData
        self.function = function
    }
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    fileprivate func createBodyWithParameters(/*parameters: [String: String]?, */filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        
        var body = Data()
        
        let filename = "user-profile.png"
        let mimetype = "image/png"
        
        guard let boundaryData = "--\(boundary)\r\n".data(using: String.Encoding.utf8),
            let contentDisposition = "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8),
            let contentType = "Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8),
            let endBody = "\r\n".data(using: String.Encoding.utf8) else {return Data()}
        
        
        body.append(boundaryData)
        body.append(contentDisposition)
        body.append(contentType)
        
        body.append(imageDataKey)
        body.append(endBody)
        body.append(boundaryData)
        
        return body
    }
}

extension Dictionary where Key == String {
    public func  toJsonString() ->String {
        return String(data: try! JSONSerialization.data(withJSONObject: self), encoding: String.Encoding.utf8)!
    }
}
