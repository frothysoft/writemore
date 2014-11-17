//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Josh Berlin on 11/8/14.
//  Copyright (c) 2014 FrothySoft. All rights reserved.
//

import Cocoa
import CoreData

class DashboardViewController: NSViewController {

  var projects = [Project]()
  var projectStore: CoreDataProjectStore!
  var latestProject: Project?
  var projectWindowManager: ProjectWindowManager!
  var wordCountStore: WordCountStore!
  
  @IBOutlet weak var tableView: ClickableTableView!
  
  @IBOutlet var arrayController: NSArrayController!
  
  @IBOutlet weak var wordCountTextField: NSTextField!
  
  // TODO 0: Figure out how to reoopen the dashboard once it is closed.
  
  override func viewDidLoad() {
    super.viewDidLoad()
    var app: AppDelegate = NSApplication.sharedApplication().delegate as AppDelegate
    // TODO 0: Set up the view stack manually so the application delegate methods fire before this
    // viewDidLoad() method is called.
    app.configureObjects()
    projectStore = app.projectStore
    projectWindowManager = app.projectWindowManager
    wordCountStore = app.wordCountStore
    configureArrayController()
    configureTableView()
    configureView()
    configureWordCountController()
    
    // TODO 0: Do not compile this code for production.
    configureDeleteDatabaseButton()
  }
  
  @IBAction func newProjectButtonPressed(sender: AnyObject) {
    var project = projectStore.newProject()
    showProject(project)
  }
  
  func showProject(project: Project) {
    if projectWindowManager.canOpenProject(project) {
      latestProject = project
      projectWindowManager.projectOpened(project)
      performSegueWithIdentifier("newProject", sender: self)
    } else {
      // TODO 1: Bring the project to the front.
      println("Project already opened")
    }
  }
  
  override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "newProject" {
      if let pwc = segue.destinationController as? ProjectWindowController {
        pwc.project = latestProject
        if let pvc = pwc.contentViewController as? ProjectViewController {
          pvc.project = latestProject
        }
      }
    }
  }
}

// MARK: Array controller

extension DashboardViewController {
  
  var sortDescriptors: NSArray {
    var dateDescriptor = NSSortDescriptor(key: "lastModifiedDate", ascending: false)
    return [dateDescriptor]
  }
  
  func configureArrayController() {
    arrayController.managedObjectContext = projectStore.managedObjectContext
    arrayController.sortDescriptors = sortDescriptors
  }
  
}

// MARK: Table view

extension DashboardViewController: ClickableTableViewDelegate, NSTableViewDelegate {
  
  func configureTableView() {
    tableView.clickableTableViewDelegate = self
  }
  
  func tableView(tableView: NSTableView, didClickRow row: Int) {
    if row < 0 || row >= arrayController.arrangedObjects.count { return }
    var selectedProject = arrayController.arrangedObjects[row] as? Project
    if let ps = selectedProject {
      showProject(ps)
    }
  }
  
  func tableView(tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: NSIndexSet) -> NSIndexSet {
    return NSIndexSet()
  }
  
}

extension DashboardViewController {
  
  func configureWordCountController() {
    // TODO 0: Reset if today's word count changes to tomorrow at 4 am.
    var wordCount = wordCountStore.todaysWordCount()
    var wordCountController = NSObjectController(content: wordCount)
    wordCountTextField.bind("value", toObject: wordCountController, withKeyPath: "selection.numberOfWords", options: nil)
  }
  
}

// MARK: View

extension DashboardViewController {
  
  func configureView() {
    view.wantsLayer = true
    view.layer?.backgroundColor = NSColor.whiteColor().CGColor
  }
  
}

// TODO 0: Remove the button from the storyboard and do not compile this code for production.
// MARK: Debug

extension DashboardViewController {
  
  func configureDeleteDatabaseButton() {
    var button = NSButton(frame: NSRect(origin: NSPoint(x: 634, y: 536), size: CGSizeMake(142, 32)))
    button.title = "Delete Database"
    button.target = self
    button.action = Selector("deleteDatabaseButtonPressed:")
    button.bezelStyle = NSBezelStyle.RoundedBezelStyle
    view.addSubview(button)
  }
  
  @IBAction func deleteDatabaseButtonPressed(sender: AnyObject) {
    for project: Project in arrayController.arrangedObjects as [Project] {
      projectStore.deleteProject(project)
    }
    for wordCount: WordCount in wordCountStore.allWordCounts() {
      wordCountStore.deleteWordCount(wordCount)
    }
    configureWordCountController()
  }
}