

import CoreData
import UIKit

final class CoreManager {
    
    var delegat: AppDelegate
    var context: NSManagedObjectContext
    static let shared = CoreManager()
    
    init() {
        delegat = UIApplication.shared.delegate as! AppDelegate
        context = delegat.persistentContainer.viewContext
    }
   

}
