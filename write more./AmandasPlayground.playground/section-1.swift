// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

println(str)

class Drink {
  
  var name: String!
  var color: String!
  
}

var willamettePinotNoir = Drink()
willamettePinotNoir.name = "Willamette Pinot Noir"
willamettePinotNoir.color = "Red"

println(willamettePinotNoir.name)
println(willamettePinotNoir.color)

class Wine: Drink {
  
  var year: Int!
  var type: String!
  
  func printWineLabel(isTheFormattingPretty: Bool) {
    if isTheFormattingPretty {
      println(name + " " + color + " " + type + " \(year)")
    } else {
      println(name + color + type + "\(year)")
    }
  }
  
}

var menageATrois = Wine()
menageATrois.year = 2007
menageATrois.name = "Menage A Trois"
menageATrois.type = "Pinot Noir"
menageATrois.color = "Red"

println(menageATrois.year)
println(menageATrois.color)
println(menageATrois.name)
println(menageATrois.year+5)

menageATrois.printWineLabel(false)
menageATrois.printWineLabel(true)