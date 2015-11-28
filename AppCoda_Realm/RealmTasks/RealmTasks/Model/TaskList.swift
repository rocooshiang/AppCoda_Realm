//
//  TaskList.swift
//  RealmTasks
//
//  Created by Hossam Ghareeb on 10/13/15.
//  Copyright © 2015 Hossam Ghareeb. All rights reserved.
//

import RealmSwift


class TaskList: Object {
    
    //List<T> is generic data type and that’s why we didn’t add dynamic before declaring tasks property because the generic properties can’t be represented in Objective-C runtime.
    
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    let tasks = List<Task>()
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
