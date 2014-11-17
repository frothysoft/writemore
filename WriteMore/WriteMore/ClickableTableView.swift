//
//  ClickableTableView.swift
//  WriteMore
//
//  Created by Josh Berlin on 11/11/14.
//  Copyright (c) 2014 FrothySoft. All rights reserved.
//

import Cocoa

protocol ClickableTableViewDelegate {
  
  func tableView(tableView: NSTableView, didClickRow row: Int)
  
}

class ClickableTableView: NSTableView {
  
  var clickableTableViewDelegate: ClickableTableViewDelegate? = nil
  
  override func mouseDown(theEvent: NSEvent) {
    var globalLocation = theEvent.locationInWindow
    var localLocation = convertPoint(globalLocation, fromView: nil)
    var clickedRow = rowAtPoint(localLocation)
  
    super.mouseDown(theEvent)
  
    if clickedRow != -1 {
      clickableTableViewDelegate?.tableView(self, didClickRow: clickedRow)
    }
  }
}
