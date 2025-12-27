//
//  Observable.swift
//  ProductPagination
//
//  Created by Sharad Shakya on 26/12/25.
//

import Foundation

class Observable<T> {
    
    var value : T {
        didSet {
            listener?(value)
        }
    }
    
    var listener : ((T) -> Void)?
    
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure : @escaping (T) -> Void) {
        closure(value)
        listener =  closure
    }
}

