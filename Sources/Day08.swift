import Algorithms
import Foundation

struct Day08: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
  
  // Splits input data into its component parts and convert from string.
  var entities: [[[Int]]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").compactMap { String($0).split(separator: ",").compactMap { Int($0) } }
    }
  }
  
  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Int {
    guard let circuits = entities.first else { return 0 }
    
    let pairSize: Int = 1000
    
    // calc pair
    var pairs: [(Double, (Int, Int))] = []
    for i in 0..<circuits.count {
      for j in i+1..<circuits.count {
        let pair: (Int, Int) = (i, j)
        let x = pow(Double(circuits[i][0] - circuits[j][0]), 2)
        let y = pow(Double(circuits[i][1] - circuits[j][1]), 2)
        let z = pow(Double(circuits[i][2] - circuits[j][2]), 2)
        pairs.append((x + y + z, pair))
      }
    }
    pairs = Array(pairs.sorted(by: { $0.0 < $1.0 }).prefix(pairSize))
    
    var circuitSet: [Set<Int>] = []
    for pair in pairs {
      let (_, pairIndices) = pair
      let a = pairIndices.0
      let b = pairIndices.1
      
      let containIndices = circuitSet.enumerated().filter({ $0.element.contains(a) || $0.element.contains(b) }).map(\.offset)
      if !containIndices.isEmpty {
        var union = Set([a, b])
        for index in containIndices {
          union.formUnion(circuitSet[index])
        }
        circuitSet = circuitSet.enumerated().filter({ !containIndices.contains($0.offset) }).map(\.element)
        circuitSet.append(union)
      } else {
        circuitSet.append([a, b])
      }
    }
    circuitSet.sort(by: { $0.count > $1.count })
    
    return circuitSet.prefix(3).reduce(1) { $0 * $1.count }
  }
  
  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Int {
    guard let circuits = entities.first else { return 0 }
    
    // calc pair
    var pairs: [(Double, (Int, Int))] = []
    for i in 0..<circuits.count {
      for j in i+1..<circuits.count {
        let pair: (Int, Int) = (i, j)
        let x = pow(Double(circuits[i][0] - circuits[j][0]), 2)
        let y = pow(Double(circuits[i][1] - circuits[j][1]), 2)
        let z = pow(Double(circuits[i][2] - circuits[j][2]), 2)
        pairs.append((x + y + z, pair))
      }
    }
    pairs = Array(pairs.sorted(by: { $0.0 < $1.0 }))
    
    var circuitSet: [Set<Int>] = circuits.enumerated().map(\.offset).map { [$0] }
    var answerIndex: (Int, Int) = (0, 0)
    for pair in pairs {
      let (_, pairIndices) = pair
      let a = pairIndices.0
      let b = pairIndices.1
      
      let containIndices = circuitSet.enumerated().filter({ $0.element.contains(a) || $0.element.contains(b) }).map(\.offset)
      var union = Set([a, b])
      for index in containIndices {
        union.formUnion(circuitSet[index])
      }
      circuitSet = circuitSet.enumerated().filter({ !containIndices.contains($0.offset) }).map(\.element)
      circuitSet.append(union)
      
      if circuitSet.count == 1 {
        answerIndex = pairIndices
        break
      }
    }
    return circuits[answerIndex.0][0] * circuits[answerIndex.1][0]
  }
}
