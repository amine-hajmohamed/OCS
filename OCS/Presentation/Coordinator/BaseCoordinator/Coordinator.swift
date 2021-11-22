//
//  Coordinator.swift
//  OCS
//
//  Created by Mohamed Amine HAJ MOHAMED on 22/11/2021.
//

protocol Coordinator: AnyObject, Presentable {
    
    var onCompletion: (() -> Void)? { get }
    
    func start()
}
