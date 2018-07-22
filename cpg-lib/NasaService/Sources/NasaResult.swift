//
//  NasaServiceQuery.swift
//  NasaService
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import Foundation

public struct NetworkError: Decodable, Error, LocalizedError {
    
    public let code: Int
    public let message: String
    
    public var errorDescription: String? {
        return message
    }
}

public enum NasaResultError: Error, LocalizedError {
    
    case client(Error)
    case network(NetworkError)
    case service(NasaServiceError)
    
    public var errorDescription: String? {
        switch self {
        case .client(let error):
            return error.localizedDescription
        case .network(let error):
            return error.localizedDescription
        case .service(let error):
            return error.message
        }
    }
}

public enum NasaResult<Result: Decodable> {
    
    case success(Result?)
    case failure(Error)
    
    static func json(data: Data?, response: URLResponse?, error: Error?) -> NasaResult<Result> {
        
        if let clientError = error {
            return .failure(NasaResultError.client(clientError))
        }
        
        guard let responseData = data else {
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let errorInfo = NetworkError(
                    code: httpResponse.statusCode,
                    message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                )
                return .failure(NasaResultError.network(errorInfo))
            }
            return .success(nil)
        }
        print(jsonData: responseData)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy =  .convertFromSnakeCase
        
        do {
            let result = try decoder.decode(Result.self, from: responseData)
            if let failableResult = result as? FailableResult, let serviceError = failableResult.error {
                return .failure(NasaResultError.service(serviceError))
            } else {
                return .success(result)
            }
        } catch {
            dprint(error)
            return .success(nil)
        }
    }
    
    public static func object(result: Result?, error: Error?) -> NasaResult<Result> {
        if let err = error {
            return .failure(err)
        } else {
            return .success(result)
        }
    }
}

func print(jsonData: Data) {
    guard isDebug else { return }
    guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) else { return }
    guard let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else { return }
    guard let str = String.init(data: data, encoding: .utf8) else { return }
    print(str)
}
