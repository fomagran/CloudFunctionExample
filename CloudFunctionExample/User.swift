//
//  User.swift
//  CloudFunctionExample
//
//  Created by Fomagran on 2021/04/21.
//

import Foundation

struct User:Codable {
    let name:String
    let age:Int
    let description:String
    
    init(name:String,age:Int,desc:String) {
        self.name = name
        self.age = age
        self.description = desc
    }
}
