//
//  AAPIManager.swift
//  AAPIManager
//
//  Created by HOANDHTB on 3/6/21.
//  Copyright © 2021 HOANDHTB. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import ObjectMapper

public class APIManager {
    
    public var sessionManager: Session
    public init(){
        //sessionManager = SessionManager.default
        let timeout = 60
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = TimeInterval(timeout)
        configuration.timeoutIntervalForRequest = TimeInterval(timeout)
        sessionManager = Alamofire.Session(configuration: configuration)
    }
    
    public func get(_ target: TargetType) -> Observable<String> {
        return Observable<String>.create({[weak self] observer in
            
            if(!NetworkConnectivity.isConnectedToInternet)
            {
                observer.onError(AAPIManagerError.NetWorkError)
            }
            let request: URLRequest = target.getRequestProtocol().getRequest()
            self?.sessionManager.request(request)
                .responseString{ response in
                    switch response.result {
                    case .success :
                        print("http code \(response.response?.statusCode ?? 0)")
                        if response.response?.statusCode == 401 || response.response?.statusCode == 403 {
                            observer.onError(AAPIManagerError.Unauthorized)
                        }else{
                            observer.onNext(response.value!)
                            observer.onCompleted()
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        })
    }
    
    open func getItem<T:ImmutableMappable>(_ type:T.Type, _ target:TargetType) -> Observable<T>{
        
        return self.get(target)
            .map{Mapper<T>().map(JSONString: $0)!}
    }
    
    open func getItem<T:Mappable>(_ type:T.Type, _ target:TargetType) -> Observable<T>{
        return self.get(target)
            .map{Mapper<T>().map(JSONString: $0)!}
    }
    
    open func getItems<T:ImmutableMappable>(_ type:T.Type, _ target:TargetType) -> Observable<[T]>{
        
        return self.get(target)
            .map{Mapper<T>().mapArray(JSONString: $0)!}
    }
    
    open func getItems<T:Mappable>(_ type:T.Type, _ target:TargetType) -> Observable<[T]>{
        return self.get(target)
            .map{Mapper<T>().mapArray(JSONString: $0)!}
    }
}


public enum AAPIManagerError:Error{
    case NetWorkError
    case ParseError
    case EncryptError
    case Cancel
    case Error(code:String,message:String,json:String)
    case Unauthorized
}
