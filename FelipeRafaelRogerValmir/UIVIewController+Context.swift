//
//  UIVIewController+Context.swift
//  FelipeRafaelRogerValmir
//
//  Created by iterative on 26/04/20.
//  Copyright © 2020 FelipeRafaelRogerValmir. All rights reserved.
//
import CoreData
import UIKit

extension UIViewController {
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
