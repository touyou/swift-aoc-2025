import Algorithms

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[String]] {
    data.split(separator: "\n").map {
      $0.split(separator: ",").compactMap { String($0) }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int64 {
    var result: Int64 = 0
    guard let entity = entities.first else { return result }
    
    for idRange in entity {
      let ranges = idRange.split(separator: "-").compactMap { Int64($0) }
      guard ranges.count == 2 else { continue }
      for x in ranges[0]...ranges[1] {
        let strX = String(x)
        guard strX.count % 2 == 0 else { continue }
        let firstHalf = String(strX.prefix(strX.count / 2))
        let secondHalf = String(strX.suffix(strX.count / 2))
        if firstHalf == secondHalf {
          result += x
        }
      }
    }
    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int64 {
    var result: Int64 = 0
    guard let entity = entities.first else { return result }
    
    for idRange in entity {
      let ranges = idRange.split(separator: "-").compactMap { Int64($0) }
      guard ranges.count == 2 else { continue }
      for x in ranges[0]...ranges[1] {
        let strX = String(x)
        for splitBase in (1..<strX.count).filter({ strX.count % $0 == 0 }) {
          let splitStrX = strX.chunks(ofCount: splitBase).map(String.init)
          if let firstSplit = splitStrX.first,
             splitStrX.allSatisfy({ $0 == firstSplit }) {
            result += x
            break
          }
        }
      }
    }
    
    return result
  }
}
