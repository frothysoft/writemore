//
//  WordCount.swift
//  WriteMore
//
//  Created by Josh Berlin on 11/12/14.
//  Copyright (c) 2014 FrothySoft. All rights reserved.
//

import Cocoa

class WordCount: NSManagedObject {
  @NSManaged var numberOfWords: Int
  @NSManaged var date: NSDate
}

protocol WordCountStore {
  
  func todaysWordCount() -> WordCount!
  func allWordCounts() -> [WordCount]!
  func deleteWordCount(wordCount: WordCount) -> Bool
  
}

class CoreDataWordCountStore: WordCountStore {
  
  var managedObjectContext: NSManagedObjectContext?
  
  init(managedObjectContext: NSManagedObjectContext) {
    self.managedObjectContext = managedObjectContext
  }
  
  func todaysWordCount() -> WordCount! {
    if let moc = managedObjectContext {
      var fetch = todaysWordCountFetchRequest()
      var wordCountsToday = moc.executeFetchRequest(fetch, error: nil)
      if let wcs = wordCountsToday as [WordCount]! {
        var wordCount: WordCount! = nil
        if wcs.count == 0 {
          return newWordCount()
        } else if wcs.count == 1 {
          return wcs.first
        } else {
          // TODO 0: Handle failure.
          assertionFailure("The database must contain either 0 or 1 word counts")
          return nil
        }
      } else {
        // TODO 0: Handle failure.
        return nil
      }
    } else {
      // TODO 0: Handle failure.
      println("MOC is nil. Word count can not be created.")
      return nil
    }
  }
  
  func todaysWordCountFetchRequest() -> NSFetchRequest {
    var fetch = NSFetchRequest(entityName: "WordCount")
    var now = NSDate()
    // TODO 0: This is from 2 am to 2am the next day. Make this more robust.
    var todaysComponenents = NSCalendar.currentCalendar().components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit, fromDate: now)
    todaysComponenents.hour = 2
    var oneDayComponents = NSDateComponents()
    oneDayComponents.day = 1
    
    var today = NSCalendar.currentCalendar().dateFromComponents(todaysComponenents)!
    var nextDay = NSCalendar.currentCalendar().dateByAddingComponents(oneDayComponents, toDate: today, options: nil)!
    
    fetch.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", today, nextDay)
    
    return fetch
  }
  
  func allWordCounts() -> [WordCount]! {
    if let moc = managedObjectContext {
      var fetch = NSFetchRequest(entityName: "WordCount")
      var wordCounts = moc.executeFetchRequest(fetch, error: nil)
      if let wcs = wordCounts as [WordCount]! {
        return wcs
      } else {
        // TODO 0: Handle error.
        return nil;
      }
    } else {
      // TODO 0: Handle error.
      return nil
    }
  }
  
  func deleteWordCount(wordCount: WordCount) -> Bool {
    if let moc = managedObjectContext {
      moc.deleteObject(wordCount)
      return true
    } else {
      // TODO 0: Handle failure.
      println("MOC is nil. Word count can not be deleted.")
      return false
    }
  }
  
  func newWordCount() -> WordCount! {
    if let moc = managedObjectContext {
      let wordCount = NSEntityDescription.insertNewObjectForEntityForName("WordCount", inManagedObjectContext: moc) as WordCount
      wordCount.numberOfWords = 0
      wordCount.date = NSDate()
      return wordCount
    } else {
      // TODO 0: Handle failure.
      println("MOC is nil. Word count can not be created.")
      return nil
    }
  }
  
}