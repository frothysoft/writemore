//
//  Colors.swift
//  FindMyPet
//
//  Created by Josh Berlin on 6/23/14.
//  Copyright (c) 2014 Frothy Software. All rights reserved.
//

import Cocoa

extension NSColor {
  
  convenience init(rgbValue: UInt) {
    self.init(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
  convenience init(rgbValue: UInt, alpha: CGFloat) {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  class func greyTextColor() -> NSColor { return NSColor(rgbValue: 0x000000, alpha: 0.70) }
  class func greenTextColor() -> NSColor { return NSColor(rgbValue: 0x6BB718) }
  
  class func greyStatusColor() -> NSColor { return NSColor(rgbValue: 0xC2BEA8) }
  class func greenStatusColor() -> NSColor { return NSColor(rgbValue: 0x6BB718) }
  
}