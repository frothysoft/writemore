//
//  ProjectWindowController.swift
//  WriteMore
//
//  Created by Josh Berlin on 11/11/14.
//  Copyright (c) 2014 FrothySoft. All rights reserved.
//

import Cocoa

// TODO 1: Move this class.
// TODO 1: Take manager out of the name.
class ProjectWindowManager {
  
  var openProjects: [Project]! = []
  
  func canOpenProject(project: Project) -> Bool {
    return !contains(openProjects, project)
  }
  
  func projectOpened(project: Project) {
    assert(canOpenProject(project), "Project is already opened. \(project)")
    openProjects.append(project)
  }
  
  func projectClosed(project: Project) {
    if let index = find(openProjects, project) {
      openProjects.removeAtIndex(index)
    } else {
      // TODO 1: Use a logging framework.
      println("WARNING: Closing a project that is not opened.")
    }
  }
  
}

class ProjectWindowController: NSWindowController, NSWindowDelegate {

  var project: Project?
  var projectWindowManager: ProjectWindowManager!
  
  override func windowDidLoad() {
    super.windowDidLoad()
    var app: AppDelegate = NSApplication.sharedApplication().delegate as AppDelegate
    projectWindowManager = app.projectWindowManager
  }

  func windowWillClose(notification: NSNotification) {
    if let p = project {
      projectWindowManager.projectClosed(p)
    }
  }
  
}
