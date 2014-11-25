//
//  ProjectViewController.swift
//  WriteMore
//
//  Created by Josh Berlin on 11/9/14.
//  Copyright (c) 2014 FrothySoft. All rights reserved.
//

import Cocoa

class ProjectViewController: NSViewController, NSTextViewDelegate {
  
  var wordCountStore: WordCountStore!
  var previousWordCount: Int = 0
  
  @IBOutlet var textView: NSTextView!
  
  var project: Project? {
    
    didSet {
      if let p = project {
        previousWordCount = countWords(p.text.string)
      }
    }
  }
  
  // TODO 1: Do all this in the window controller.
  func configureViewController() {
    var app: AppDelegate = NSApplication.sharedApplication().delegate as AppDelegate
    wordCountStore = app.wordCountStore
    configureView()
    configureTextView()
    if let p = project { textView.textStorage?.setAttributedString(p.text) }
  }
  
  func textDidChange(notification: NSNotification) {
    if let p = project {
      p.text = textView.attributedString()
      p.lastModifiedDate = NSDate()
      updateWordCount()
    }
  }
  
}

// MARK: Word count

extension ProjectViewController {
  
  func updateWordCount() {
    var wordCount = countWords(textView.string!)
    println("Word count: \(wordCount) Previous word count: \(previousWordCount)")
    // TODO 0: Handle the case where you are writing at night and you go over to the next day.
    if wordCount > previousWordCount {
      var todaysWordCount = wordCountStore.todaysWordCount()
      todaysWordCount.numberOfWords++
    }
    previousWordCount = wordCount
  }
  
  func countWords(s: String) -> Int {
    // TODO 0: Return 0 for a string containing all whitespace.
    // TODO 0: Trim leading and trailing whitespace.
    if (s.isEmpty) { return 0 }
    var words = s.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    return words.count
  }
  
}

// MARK: View

extension ProjectViewController {
  
  func configureView() {
    view.wantsLayer = true
    view.layer?.backgroundColor = NSColor.whiteColor().CGColor
  }
  
  func configureTextView() {
    textView.font = NSFont(name: "Avenir Next", size: 13)
  }
  
}