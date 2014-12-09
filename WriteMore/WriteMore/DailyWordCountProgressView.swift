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
    let maxX = CGRectGetMaxX(dirtyRect)
    
    let leftMostCircleCenterX = minX + circleSize.width / 2.0
    let leftMostCircleCenterY = midY
    
    var leftMostCircleCenter = NSMakePoint(leftMostCircleCenterX, leftMostCircleCenterY)
    
    var circleCenter = leftMostCircleCenter
    
    var test = 0
    
    let linePath = NSBezierPath()
    let circlePaths = [NSBezierPath]()
    
    for wordCountDisplayable: WordCountDisplayable! in wordCountDisplayables {
      if let wcd = wordCountDisplayable {
        
        let dateStringRect = CGRectMake(circleCenter.x + 10, circleCenter.y + circleSize.height / 2, 40, 30)
        
        if let dateStringFont = NSFont(name: "Avenir Next", size: 16) {
          let paragraphStyle = NSMutableParagraphStyle()
          paragraphStyle.alignment = NSTextAlignment.LeftTextAlignment
          let dateStringAttributes = [NSFontAttributeName: dateStringFont, NSParagraphStyleAttributeName: paragraphStyle]
          wcd.dateString.drawInRect(dateStringRect, withAttributes: dateStringAttributes)
        }
        
        let circleRect = CGRectMake(circleCenter.x + circleSize.width, circleCenter.y - circleSize.height, circleSize.width, circleSize.height)
        let circlePath = NSBezierPath(ovalInRect: circleRect)
        wcd.statusColor.setFill()
        circlePath.fill()
        
        let linePoint = CGPointMake(CGRectGetMidX(circleRect), CGRectGetMidY(circleRect))
        if linePath.empty {
          linePath.moveToPoint(linePoint)
        } else {
          linePath.lineToPoint(linePoint)
        }
      } else {
        // TODO 0: Handle error.
        assertionFailure("ERROR: No word count displayable.")
      }
      
      let previousCircleCenter = circleCenter
      
      circleCenter.x = circleCenter.x + circleSpacing * 2 + circleSize.width
    }
    
    NSGraphicsContext.currentContext()?.compositingOperation = NSCompositingOperation.CompositeDestinationAtop
    NSColor(rgbValue: 0x979797).setStroke()
    linePath.stroke()
  }
  
}
