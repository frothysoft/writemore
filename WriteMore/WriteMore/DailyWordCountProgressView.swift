//
//  DailyWordCountProgressView.swift
//  WriteMore
//
//  Created by Josh Berlin on 11/24/14.
//  Copyright (c) 2014 FrothySoft. All rights reserved.
//

import Cocoa

class DailyWordCountProgressView: NSView {

  var wordCountDisplayables: [WordCountDisplayable]! = []
  
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    
    let circleSize = CGSizeMake(20.0, 20.0)
    let circleSpacing: CGFloat = 25.0
    
    let midX = CGRectGetMidX(dirtyRect)
    let midY = CGRectGetMidY(dirtyRect)
    let minX = CGRectGetMinX(dirtyRect)
    
    let leftMostCircleCenterX = minX + circleSize.width / 2.0
    let leftMostCircleCenterY = midY
    
    var leftMostCircleCenter = NSMakePoint(leftMostCircleCenterX, leftMostCircleCenterY)
    
    var circleCenter = leftMostCircleCenter
    
    for wordCountDisplayable: WordCountDisplayable! in wordCountDisplayables {
      if let wcd = wordCountDisplayable {
        
        println("\(wcd.dateString) \(wcd.numberOfWords)")
        
        let dateStringPoint = NSMakePoint(circleCenter.x, circleCenter.y + circleSize.height / 2)
        
        if let dateStringFont = NSFont(name: "Avenir Next", size: 16) {
          let dateStringAttributes = [NSFontAttributeName: dateStringFont]
          wcd.dateString.drawAtPoint(dateStringPoint, withAttributes:dateStringAttributes)
        }
        
        var circlePath = NSBezierPath(ovalInRect: CGRectMake(circleCenter.x + circleSize.width, circleCenter.y - circleSize.height, circleSize.width, circleSize.height))
        wcd.statusColor.setFill()
        circlePath.fill()
      } else {
        // TODO 0: Handle error.
        assertionFailure("ERROR: No word count displayable.")
      }
      
      circleCenter.x = circleCenter.x + circleSpacing * 2 + circleSize.width
    }
  }
  
}
