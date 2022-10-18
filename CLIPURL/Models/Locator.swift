//
//  Locator.swift
//  URList
//
//  Created by t&a on 2022/10/13.
//

import UIKit
import RealmSwift

// MARK: - Article
class Locator:Object,ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id:ObjectId
    @Persisted var title:String
    @Persisted var url:String
    @Persisted var memo:String
    @Persisted var date:Date = Date()
    @Persisted var category:String
}

// MARK: - Group
class Category:Object,ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id:ObjectId
    @Persisted var category:String
}

