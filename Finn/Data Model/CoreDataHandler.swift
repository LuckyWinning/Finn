//
//  CoreDataHandler.swift
//  Finn
//
//  Created by Lucky on 2/28/18.
//  Copyright © 2018 Lucky. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject {
//  While researching for a method of how to save persistent data, the best answer that I could find was CoreData, because of the size (potentially 1000 ads) and the performance
//  All this section is just the set up and definition of the function needs it to save, delete and delete all the information of the ads  
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveObject(coreName: String, coreLocation: String, corePrice: String, coreImg: NSData, coreId: String) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "CoreItem", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(coreName, forKey: "coreName")
        manageObject.setValue(coreLocation, forKey: "coreLocation")
        manageObject.setValue(corePrice, forKey: "corePrice")
        manageObject.setValue(coreImg, forKey: "coreImg")
        manageObject.setValue(coreId, forKey: "coreId")
        
        do{
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func fetchObject() -> [CoreItem]? {
        let context = getContext()
        var coreItem: [CoreItem]? = nil
        do {
            coreItem = try context.fetch(CoreItem.fetchRequest())
            return coreItem
        } catch {
            return coreItem
        }
    }
    
    class func deleteObject(coreItem: CoreItem) -> Bool {
        let context = getContext()
        context.delete(coreItem)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func cleanDelete() -> Bool {
// this function is the one how deletes all. I though it was a functional need by a user
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: CoreItem.fetchRequest())
        
        do {
            try context.execute(delete)
            return true
        } catch {
            return false
        }
    }

}
