//
//  Configurations.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 18/11/2021.
//

import Foundation

class Configurations {
    
    static let current = Configurations(bundle: Bundle(for: Configurations.self))
    
    private let bundle: Bundle
    
    init(bundle: Bundle) {
        self.bundle = bundle
    }
    
    var baseApiURL: String { bundle.infoForKey("BASE_API_URL") }
    var baseRessourcesURL: String { bundle.infoForKey("BASE_RESSOURCES_URL") }
}

private extension Bundle {
    
    func infoForKey(_ key: String) -> String {
        guard let value = (infoDictionary?[key] as? String)?.replacingOccurrences(of: "\\", with: "") else {
            fatalError("Missing value for key \(key)")
        }
        
        return value
    }
}
