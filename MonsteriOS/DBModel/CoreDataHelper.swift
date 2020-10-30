//
//  CoreDataHelper.swift
//  CoreDataHelper
//
//  Created by Anupam Katiyar.
//  Copyright © 2015 Anupam Katiyar. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper1 {

    // Returns NSFetchRequest Object for the Model Class passed in parameter.
    // Invoke SharedAppDelegate.managedObjectContext.executeFetchRequest(request)
    // in order to get only the entries  in Database, which follows the Predicate passed as parameter
    class func getFetchRequestforModelClass(_ className : NSManagedObject.Type, predicate : NSPredicate? = nil) -> NSFetchRequest<NSFetchRequestResult> {

        let stringClassName = String(describing: className)
        //String(stringInterpolationSegment: className)
        let entityDescription = NSEntityDescription.entity(forEntityName: stringClassName, in: AppDelegate.instance.managedObjectContext)
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription

        if let pred = predicate {
            request.predicate = pred
        }
        return request
    }

    // Returns NSBatchDeleteRequest in Object for the Model Class passed in parameter.
    // Invoke SharedAppDelegate.persistentStoreCoordinator.executeRequest(...)
    // in order to clear the Database
    class func getDeleteRequestforModelClass(_ className: NSManagedObject.Type) -> NSBatchDeleteRequest {
        let fetchRequest = self.getFetchRequestforModelClass(className)
        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }
    
    @discardableResult
    class func deleteDataForClass<T: NSManagedObject>(_ className: T.Type) -> Bool {
        let deleteReq = CoreDataHelper1.getDeleteRequestforModelClass(className)
        do {
            try AppDelegate.instance.managedObjectContext.execute(deleteReq)
            return true
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            return false
        }
    }
    
    
    // Returns Object for the Model Class passed in parameter.
    // Assign values to the attributes for the object and
    // Invoke SharedAppDelegate.managedObjectContext.save()
    // in order to save the entry in Database
//    class func getInstanceOfModelClass<T: NSManagedObject>(_ className: T.Type) -> T {
//
////        if #available(iOS 10.0, *) {
//        if #available(iOS 10.0, *) {
//            let instance = className.init(context: AppDelegate.instance.managedObjectContext)
//        } else if #available(iOS 9.0, *){
////            stringInterpolationSegment: className
//                        let stringClassName = String(stringInterpolation: className.typ)
//                        let entityDescription = NSEntityDescription.entity(forEntityName: stringClassName, in: AppDelegate.instance.managedObjectContext)
//                        let instance = className.init(entity: entityDescription!, insertInto: AppDelegate.instance.managedObjectContext)
//                        return instance
//        }
//        } else {
//            //stringInterpolationSegment: className
//            let stringClassName = String(stringInterpolation: className.typ)
//            let entityDescription = NSEntityDescription.entity(forEntityName: stringClassName, in: AppDelegate.instance.managedObjectContext)
//            let instance = className.init(entity: entityDescription!, insertInto: AppDelegate.instance.managedObjectContext)
//            return instance
//        }
//    }
    
    class func getDataForClass<T: NSManagedObject>(_ className: T.Type, predicate : NSPredicate? = nil, sort: [NSSortDescriptor]? = nil) -> [T] {
        // let predicate = NSPredicate(format: "(YOUR_COLOM_NAME == %@)", VALUE_TO_CHECK)
        let fetchReq = CoreDataHelper1.getFetchRequestforModelClass(className, predicate: predicate)
        fetchReq.sortDescriptors = sort

        do {
            let result = try AppDelegate.instance.managedObjectContext.fetch(fetchReq)
            return result as! [T]
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return []
    }
}


extension Int {
    var int64: Int64 {
        return Int64(self)
    }
    var stringValue: String {
        return String(self)
    }
}
extension Int64 {
    var stringValue: String {
        return String(self)
    }
}
