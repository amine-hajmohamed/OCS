//
//  Configurations.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 18/11/2021.
//

import Foundation

class Configurations {
    
    private let bundle: Bundle
    
    init(bundle: Bundle) {
        self.bundle = bundle
    }
    
    var baseUrl: String { bundle.infoForKey("BASE_URL") }
}

private extension Bundle {
    
    func infoForKey(_ key: String) -> String {
        guard let value = (infoDictionary?[key] as? String)?.replacingOccurrences(of: "\\", with: "") else {
            fatalError("Missing value for key \(key)")
        }
        
        return value
    }
}
