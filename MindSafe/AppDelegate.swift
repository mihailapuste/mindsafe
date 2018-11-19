//
//  AppDelegate.swift
//  MindSafe
//
//  Created by Mihai Lapuste on 2018-10-24.
//  Copyright © 2018 Mihai Lapuste. All rights reserved.
//
// Worked on by: Mihai Lapuste
// - Created the ability update sundowning reminders daily
// Team MindSafe

import UIKit
import CoreData
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            FirebaseApp.configure()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            // track notification status in reference to user
        })
        
        // Default settings upon app opening
        if let sundowning = UserDefaults.standard.object(forKey: "sundowning"){
            print("Sundowning already set!")
        }
        else {
            UserDefaults.standard.set(true, forKey:"sundowning")
        }
        
        if let safezone = UserDefaults.standard.object(forKey: "safeZoneNotifications"){
            print("Safe Zone already set!")
        }
        else {
              UserDefaults.standard.set(true, forKey:"safeZoneNotifications")
        }
        
        if let safeZoneRadius = UserDefaults.standard.object(forKey: "safeZoneRadius"){
            print("Safe Zone radius already set!")
        }
        else {
            UserDefaults.standard.set(300, forKey:"safeZoneRadius")
        }
        
        if let emergencyMessage = UserDefaults.standard.object(forKey: "emergencyMessage"){
            print("emergencyMessage already set!")
        }
        else {
            UserDefaults.standard.set("Help! It's an emergency!", forKey:"emergencyMessage")
        }
        
        if let firstName = UserDefaults.standard.object(forKey: "firstName"){
            print("firstName already set!")
        }
        else {
            UserDefaults.standard.set("", forKey:"firstName")
        }
        
        if let lastName = UserDefaults.standard.object(forKey: "lastName"){
            print("lastName already set!")
        }
        else {
            UserDefaults.standard.set("", forKey:"lastName")
        }
        
        if let phoneNumber = UserDefaults.standard.object(forKey: "phoneNumber"){
            print("phoneNumber already set!")
        }
        else {
            UserDefaults.standard.set("", forKey:"phoneNumber")
        }
        
        if let email = UserDefaults.standard.object(forKey: "email"){
            print("email already set!")
        }
        else {
            UserDefaults.standard.set("", forKey:"email")
        }
        
        if let street = UserDefaults.standard.object(forKey: "street"){
            print("street already set!")
        }
        else {
            UserDefaults.standard.set("", forKey:"street")
        }
        
        if let city = UserDefaults.standard.object(forKey: "city"){
            print("city already set!")
        }
        else {
            UserDefaults.standard.set("", forKey:"city")
        }
        
        if let provstate = UserDefaults.standard.object(forKey: "provstate"){
            print("provstate already set!")
        }
        else {
            UserDefaults.standard.set("", forKey:"provstate")
        }
        
        if let zip = UserDefaults.standard.object(forKey: "zip"){
            print("zip already set!")
        }
        else {
            UserDefaults.standard.set("", forKey:"zip")
        }
        
        if let country = UserDefaults.standard.object(forKey: "country"){
            print("country already set!")
        }
        else {
            UserDefaults.standard.set("", forKey:"country")
        }
        

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

        // setting all sundowning reminders once daily
        if let date = UserDefaults.standard.object(forKey: "sundowningTime") as? Date {
            if let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour, diff > 24 && UserDefaults.standard.object(forKey: "sundowning") as? Bool == true {
                print("refreshing reminders");
                let ViewController = RemindersViewController()
                ViewController.sundowningReminders()
                
                
            }
        }
        if UserDefaults.standard.object(forKey: "sundowningTime") == nil {
            UserDefaults.standard.set(Date(), forKey:"sundowningTime")
            UserDefaults.standard.set(true, forKey:"sundowning")
        }
       
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MindSafe")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

