//
//  Parser.swift
//  QuizMobileAppMVP
//
//  Created by Giovanni Bruno on 05/11/19.
//  Copyright © 2019 Giovanni Bruno. All rights reserved.
//

import Foundation

class Parser {
    
    static let shared = Parser()
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private init() {}
    
    func decode<T: Decodable>(data: Data) -> T? {
        do {
            let obj = try decoder.decode(T.self, from: data)
            return obj
        } catch let e {
            print("error to parse.. \(e)")
            return nil
        }
    }
    
    func encode<T: Encodable>(obj: T) -> Data? {
        do {
            let data = try encoder.encode(obj)
            return data
        } catch let e {
            print("error to parse.. \(e)")
            return nil
        }
    }
}
