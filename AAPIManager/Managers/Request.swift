//
//  Request.swift
//  AAPIManager
//
//  Created by HOANDHTB on 3/6/21.
//  Copyright © 2021 HOANDHTB. All rights reserved.
//

import Foundation

public protocol RequestProtocol {
    func getRequest() -> URLRequest
    func getId() -> String
    mutating func setBodyData(_ data: Data)
}
