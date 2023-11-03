//
//  AsyncCaller.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 03/11/2023.
//

import Foundation

protocol AsyncCaller {
    associatedtype T
    associatedtype P

    func call(with parameters: P, completion: @escaping (Result<T, Error>) -> Void)
}
