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

class WordCountDisplayable {
  let dateString: String
  let numberOfWords: Int = 0
  let statusColor: NSColor
  
  class func dateFormatter() -> NSDateFormatter {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MM/d"
    return dateFormatter
  }
  
  init(wordCount: WordCount?, date: NSDate) {
    if let wc = wordCount {
      self.numberOfWords = wc.numberOfWords
      if wc.numberOfWords >= 1 {
        self.statusColor = NSColor.greenStatusColor()
      } else {
        self.statusColor = NSColor.greyStatusColor()
      }
    } else {
      self.statusColor = NSColor.greyStatusColor()
    }
    self.dateString = WordCountDisplayable.dateFormatter().stringFromDate(date)
  }
}

protocol WordCountStore {
  
  func todaysWordCount() -> WordCount!
  func pastWeeksWordCountDisplayables() -> [WordCountDisplayable]!
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
          return createWordCount()
        } else if wcs.count == 1 {
          return wcs.first
        } else {
          assertionFailure("The database must contain either 0 or 1 word counts")
          return nil
        }
      } else {
        assertionFailure("There was a problem with the today's word count fetch request.")
        return nil
      }
    } else {
      assertionFailure("MOC is nil. Word count can not be created.")
      return nil
    }
  }
  
  func allWordCounts() -> [WordCount]! {
    if let moc = managedObjectContext {
      var fetch = wordCountFetchRequest()
      var wordCounts = moc.executeFetchRequest(fetch, error: nil)
      if let wcs = wordCounts as [WordCount]! {
        return wcs
      } else {
        assertionFailure("There was a problem with the all word counts fetch request.")
        return nil;
      }
    } else {
      assertionFailure("MOC is nil. Word counts can not be retrieved.")
      return nil
    }
  }
  
  func deleteWordCount(wordCount: WordCount) -> Bool {
    if let moc = managedObjectContext {
      moc.deleteObject(wordCount)
      return true
    } else {
      assertionFailure("MOC is nil. Word count can not be deleted.")
      return false
    }
  }
  
  func createWordCount() -> WordCount! {
    if let moc = managedObjectContext {
      let wordCount = NSEntityDescription.insertNewObjectForEntityForName("WordCount", inManagedObjectContext: moc) as WordCount
      wordCount.numberOfWords = 0
      wordCount.date = NSDate()
      return wordCount
    } else {
      assertionFailure("MOC is nil. Word count can not be created.")
      return nil
    }
  }
  
  func pastWeeksWordCountDisplayables() -> [WordCountDisplayable]! {
    if let moc = managedObjectContext {
      var pastWeeksWordCountDisplayables: [WordCountDisplayable]! = []
      var startDate = oneWeekBeforeTodaysDate()
      for (var i = 0; i < 7; i++) {
        var nextDate = dayAfterDate(startDate)
        var fetch = wordCountFetchRequestFromDate(startDate, toDate: nextDate)
        var wordCounts = moc.executeFetchRequest(fetch, error: nil)
        if let wcs = wordCounts as [WordCount]! {
          if wcs.count == 1 {
            let wordCount = wcs.first!
            var wordCountDisplayable = WordCountDisplayable(wordCount: wordCount, date: wordCount.date)
            pastWeeksWordCountDisplayables.append(wordCountDisplayable)
          } else {
            var wordCountDisplayable = WordCountDisplayable(wordCount: nil, date: startDate)
            // TODO 0: Check if the startDate is before the first application launch time. Those 
            // word counts might still be displayed in the UI, but will be grayed out.
            pastWeeksWordCountDisplayables.append(wordCountDisplayable)
          }
        } else {
          assertionFailure("There was a problem with the past weeks word count fetch request.")
          return nil
        }
        startDate = nextDate
      }
      return pastWeeksWordCountDisplayables
    } else {
      assertionFailure("MOC is nil. Past week word counts can not be retrieved.")
      return nil
    }
  }
  
}

// MARK: Fetch requests

extension CoreDataWordCountStore {

  func todaysWordCountFetchRequest() -> NSFetchRequest {
    var today = todaysDate()
    var nextDay = dayAfterDate(today)
    var fetch = wordCountFetchRequestFromDate(today, toDate: nextDay)
    return fetch
  }
  
  func wordCountFetchRequestFromDate(fromDate: NSDate, toDate: NSDate) -> NSFetchRequest {
    var fetch = wordCountFetchRequest()
    fetch.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", fromDate, toDate)
    return fetch
  }
  
  func wordCountFetchRequest() -> NSFetchRequest {
    return NSFetchRequest(entityName: "WordCount")
  }

}

// MARK: Date functions

extension CoreDataWordCountStore {

  func todaysDate() -> NSDate {
    // TODO 0: This is from 2 am to 2am the next day. Make this more robust.
    var now = NSDate()
    var todaysComponenents = NSCalendar.currentCalendar().components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit, fromDate: now)
    todaysComponenents.hour = 2
    var today = NSCalendar.currentCalendar().dateFromComponents(todaysComponenents)!
    return today
  }
  
  func dayAfterDate(date: NSDate) -> NSDate {
    let secondsInOneDay = 86400.0
    var nextDay = date.dateByAddingTimeInterval(secondsInOneDay)
    return nextDay
  }
  
  func oneWeekBeforeTodaysDate() -> NSDate {
    var today = todaysDate()
    var nextDay = dayAfterDate(today)
    var oneWeekBeforeTodaysDate = oneWeekBeforeDate(nextDay)
    return oneWeekBeforeTodaysDate
  }
  
  func oneWeekBeforeDate(date: NSDate) -> NSDate {
    let numberOfSecondsInAWeek = 604800.0
    var oneWeekBeforeDate = date.dateByAddingTimeInterval(-numberOfSecondsInAWeek)
    return oneWeekBeforeDate
  }

}