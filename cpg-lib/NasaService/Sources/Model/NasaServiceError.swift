//
//  NasaServiceError.swift
//  NasaService
//
//  Created by Alexey Averkin on 21/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

public struct NasaServiceError: Decodable, Error, LocalizedError {
    
    public let code: String
    public let message: String
    
    public var errorDescription: String? {
        return message
    }
}
