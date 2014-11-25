//
//  Model.swift
//  CoreDataTest
//
//  Created by Josh Berlin on 11/8/14.
//  Copyright (c) 2014 FrothySoft. All rights reserved.
//

import Foundation
import Cocoa
import CoreData

class Project: NSManagedObject {
  @NSManaged var text: NSAttributedString
  @NSManaged var lastModifiedDate: NSDate
  
  // TODO 0: Store the title in core data.
  lazy var title: NSAttributedString = {
    if self.text.length == 0 {
      return NSAttributedString(string: "New Project")
    } else {
      return self.text
    }
    }()
}

protocol ProjectStore {
  
  func newProject() -> Project!
  func deleteProject(project: Project) -> Bool
  
}

class CoreDataProjectStore: ProjectStore {
  
  var managedObjectContext: NSManagedObjectContext?
  
  init(managedObjectContext: NSManagedObjectContext) {
    self.managedObjectContext = managedObjectContext
  }
  
  func newProject() -> Project! {
    if let moc = managedObjectContext {
      let project = NSEntityDescription.insertNewObjectForEntityForName("Project", inManagedObjectContext: moc) as Project
      project.text = NSAttributedString(string: "")
      project.lastModifiedDate = NSDate()
      return project
    } else {
      // TODO 0: Handle failure.
      println("MOC is nil. Project can not be created.")
      return nil
    }
  }
  
  func deleteProject(project: Project) -> Bool {
    if let moc = managedObjectContext {
      moc.deleteObject(project)
      return true
    } else {
      // TODO 0: Handle failure.
      println("MOC is nil. Project can not be deleted.")
      return false
    }
  }
  
}
