//
//  AppDelegate.swift
//  write more.
//
//  Created by Josh Berlin on 10/2/14.
//  Copyright (c) 2014 FrothySoft. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate, NSTextFieldDelegate {
                            
  @IBOutlet weak var window: NSWindow!

  @IBOutlet var wordCountLabel: NSTextField!
  @IBOutlet var textView: NSTextView!
  
  var previousWordCount: Int = 0
  var wordCountToday: Int = 0
  
  var textKey: String = "words"
  var wordCountToDateMapKey: String = "wordCount"
  
  var autoSaveTimer: NSTimer!
  
  func applicationDidFinishLaunching(aNotification: NSNotification?) {
    window.backgroundColor = NSColor.whiteColor()
    textView.font = NSFont(name: "Avenir Next", size: 13)
    restoreText()
    restoreTodaysWordCount()
    startAutoSaveTimer()
  }
  
  func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication!) -> Bool {
    return true
  }

  func applicationWillTerminate(aNotification: NSNotification?) {
    saveText()
    saveTodaysWordCount()
    stopAutoSaveTimer()
  }

  func textDidChange(notification: NSNotification!) {
    updateWordCount()
  }
  
  func updateWordCount() {
    var wc = wordCount(textView.textStorage.string)
    if wc > previousWordCount { wordCountToday++ }
    previousWordCount = wc
    updateTodaysWordCountString()
    saveTodaysWordCount()
  }
  
  func updateTodaysWordCountString() {
    var wordCountString = stringFromWordCount(wordCountToday)
    wordCountLabel.stringValue = wordCountString
  }
  
  func saveText() {
    var data: NSData = NSKeyedArchiver.archivedDataWithRootObject(textView.textStorage)
    data.writeToFile("text", atomically: true)
  }
  
  func restoreText() {
    var data: NSData? = NSData.dataWithContentsOfFile("text", options: .DataReadingMappedIfSafe, error: nil)
    if let d = data {
      var text: NSAttributedString = NSKeyedUnarchiver.unarchiveObjectWithData(d) as NSAttributedString
      textView.textStorage.setAttributedString(text)
    }
  }
  
  func saveTodaysWordCount() {
    var todayString: String = todaysDateAsString()
    var wordCountToDateMap: NSDictionary? = NSUserDefaults.standardUserDefaults().valueForKey(wordCountToDateMapKey) as? NSDictionary
    if wordCountToDateMap == nil { wordCountToDateMap = NSDictionary() }
    
    var mutableWCMap = NSMutableDictionary(dictionary: wordCountToDateMap)
    mutableWCMap[todayString] = wordCountToday
    
    NSUserDefaults.standardUserDefaults().setValue(mutableWCMap.copy(), forKey: wordCountToDateMapKey)
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  func restoreTodaysWordCount() {
    var wordCountToDateMap: NSDictionary? = NSUserDefaults.standardUserDefaults().valueForKey(wordCountToDateMapKey) as? NSDictionary
    if let wcMap = wordCountToDateMap {
      println(wcMap)
      var todayString: String = todaysDateAsString()
      if wcMap[todayString] {
        wordCountToday = wcMap[todayString] as Int
        updateTodaysWordCountString()
      }
    }
  }
  
  func startAutoSaveTimer() {
    autoSaveTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("autoSave"), userInfo: nil, repeats: true)
  }
  
  func stopAutoSaveTimer() {
    autoSaveTimer.invalidate()
  }
  
  func autoSave() {
    saveText()
    saveTodaysWordCount()
  }
  
  @IBAction func displayMyStats(sender: NSObject) {
    var wordCountToDateMap: NSDictionary = NSUserDefaults.standardUserDefaults().valueForKey(wordCountToDateMapKey) as NSDictionary
    if wordCountToDateMap != nil {
      var totalWordCount: Int = 0
      for key: String in wordCountToDateMap.allKeys as [String] {
        totalWordCount += wordCountToDateMap[key] as Int
      }
      var alert: NSAlert = NSAlert()
      alert.messageText = "My Stats"
      alert.informativeText = "\(wordCountToday) words today\n\n\(totalWordCount) words total.\n\nGood job!\n\n\(wordCountToDateMap)"
      alert.runModal()
    }
  }
  
  func todaysDateAsString() -> String {
    var today: NSDate = NSDate()
    var components: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: today)
    var todayString: String = "\(components.day) \(components.month) \(components.year)"
    return todayString
  }
  
  func wordCount(s: String) -> Int {
    // TODO 0: Return 0 for a string containing all whitespace.
    // TODO 0: Trim leading and trailing whitespace.
    if (s.isEmpty) { return 0 }
    var words = s.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    return words.count
  }
  
  func stringFromWordCount(wc: Int) -> String {
    return "\(wc)"
  }
  
}