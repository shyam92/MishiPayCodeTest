//
//  DatabaseManager.swift
//  MishiPayCodeTest
//
//  Created by Shyam Bhudia on 06/09/2020.
//  Copyright © 2020 Shyam Bhudia. All rights reserved.
//

import Foundation
import RealmSwift

protocol DatabaseProtocol {
    func fetchObjects(for object: Object.Type) -> [Object]?
    
    @discardableResult
    func addObjects(with objects: [Object]) -> [Object]?
    
    @discardableResult
    func deleteObjects(_ objects: [Object]) -> Bool
    
    @discardableResult
    func deleteObjects(for type: Object.Type) -> Bool
}

class DatabaseManager: DatabaseProtocol {
    
    /// The default realm
    var defaultRealm: Realm?
    
    init(realm: Realm?) {
        defaultRealm = realm        
    }
    
    convenience init() {
        do {
            let realm = try Realm()
            self.init(realm: realm)
        } catch {
            print("Erorr - \(error.localizedDescription)")
        }
        self.init(realm: try? Realm())
    }
    
    
    /**
     Checks if an object with ID exists in Realm
     
     - parameter key: The Realm object your querying
     - parameter filter: An NSPredicate to filter by optionally.
     - parameter sort: A Keypath to sort by optionally, defaults to ascending order.
     
     - returns: A RealmList of objects if found.
     */
    func fetchObjects(for object: Object.Type) -> [Object]? {
        
        guard let objects = defaultRealm?.objects(object) else { return nil }
        ///    Return the array of objects
        
        return Array(objects)
    }
    /**
     Adds to the default Realm
     
     - parameter with: The object to write to the default Realm
     
     - returns: A Realm Object, if one was inserted.
     */
    @discardableResult
    func addObjects(with objects: [Object]) -> [Object]? {
        /// Try to write
        do {
            try defaultRealm?.write {
                defaultRealm?.add(objects, update: Realm.UpdatePolicy.all)
            }
            return objects
        } catch {
            /// Log error and return
            print("Couldn't fetch the Default Realm because \(String(describing: error.localizedDescription))")
            return nil
        }
    }
    
    
    /**
     Deletes an array of objects from Realm
     */
    @discardableResult
    func deleteObjects(_ objects: [Object]) -> Bool {
        /// Try to write
        do {
            try defaultRealm?.write {
                defaultRealm?.delete(objects)
            }
            return true
        } catch {
            /// Log error and return
            print("Couldn't fetch the Default Realm because \(String(describing: error.localizedDescription))")
            return false
        }
    }
    
    /**
     Deletes objects of type
     - parameter for: Object Type to delete
     - returns: If its was successfull
     */
    @discardableResult
    func deleteObjects(for type: Object.Type) -> Bool {
        guard let fetchedObjects = self.fetchObjects(for: type) else {
            print("No objects to delete")
            return false
        }
        return self.deleteObjects(fetchedObjects)
    }
    
    
    
}

