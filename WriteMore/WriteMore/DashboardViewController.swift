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
  @IBOutlet weak var dailyWordCountProgressView: DailyWordCountProgressView!
  
  @IBOutlet var arrayController: NSArrayController!
  
  @IBOutlet weak var wordCountTextField: NSTextField!

  func configureViewController() {
    var app: AppDelegate = NSApplication.sharedApplication().delegate as AppDelegate
    app.configureObjects()
    projectStore = app.projectStore
    projectWindowManager = app.projectWindowManager
    wordCountStore = app.wordCountStore
    configureArrayController()
    configureTableView()
    configureView()
    configureWordCountController()
    configureDailyWordCountProgressView()
  }
  
  @IBAction func newProjectButtonPressed(sender: AnyObject) {
    var project = projectStore.newProject()
    showProject(project)
  }
  
  func showProject(project: Project) {
    latestProject = project
    projectWindowManager.openProject(project)
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
    var wordCount = wordCountStore.todaysWordCount()
    var wordCountController = NSObjectController(content: wordCount)
    wordCountTextField.bind("value", toObject: wordCountController, withKeyPath: "selection.numberOfWords", options: nil)
    if let numberOfWords = wordCountTextField.stringValue.toInt() {
      if numberOfWords >= 1 {
        wordCountTextField.textColor = NSColor.greenStatusColor()
      } else {
        wordCountTextField.textColor = NSColor.greyTextColor()
      }
    }
  }
  
}

// MARK: View

extension DashboardViewController {
  
  func configureView() {
    view.wantsLayer = true
    view.layer?.backgroundColor = NSColor.whiteColor().CGColor
  }
  
  func configureDailyWordCountProgressView() {
    let wordCountDisplayables = wordCountStore.pastWeeksWordCountDisplayables()
    dailyWordCountProgressView.wordCountDisplayables = wordCountDisplayables
  }
}

// MARK: Delete database button

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
