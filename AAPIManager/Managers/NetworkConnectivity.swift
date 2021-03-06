//
//  NetworkConnectivity.swift
//  AAPIManager
//
//  Created by HOANDHTB on 3/6/21.
//  Copyright © 2021 HOANDHTB. All rights reserved.
//
import Foundation
import Alamofire

open class NetworkConnectivity {
    public class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
