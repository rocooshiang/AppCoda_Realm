//
//  AppDelegate.swift
//  RealmTasks
//
//  Created by Hossam Ghareeb on 10/12/15.
//  Copyright © 2015 Hossam Ghareeb. All rights reserved.
//

import UIKit
import RealmSwift


let uiRealm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        uiRealm.write { () -> Void in
            uiRealm.deleteAll()
        }
        
        let taskListA = TaskList()
        taskListA.name = "WishList"
        
        //#1 實體化在塞參數
        let wish1 = Task()
        wish1.name = "iPhone 7"
        wish1.notes = "64GB,Gold"
        
        //#2 Dictionary
        let wish2 = Task(value: ["name":"iPhone 6S","notes":"32GB,Silver"])
        
        //#3 Array，需按照index順序
        let wish3 = Task(value: ["iPhone 6", NSDate(), "16GB,Gold", false])
        
        taskListA.tasks.appendContentsOf([wish1,wish2,wish3])
        
        //Nested Objects
        let taskListB = TaskList(value: ["MoviesList", NSDate(), [["The Martian", NSDate(), "", false], ["The Maze Runner", NSDate(), "", true]]])
        
        uiRealm.write { () -> Void in
            uiRealm.add([taskListA, taskListB])
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

