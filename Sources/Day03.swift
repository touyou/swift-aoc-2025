import Algorithms
import Foundation

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[String]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").compactMap { String($0) }
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> UInt64 {
    guard let entity = entities.first else { return 0 }
    
    return entity.reduce(0) { result, str in
      var maxNum = 0
      var secondNum = 0
      for (index, numStr) in str.chunks(ofCount: 1).enumerated() {
        guard let num = Int(numStr) else { continue }
        if num > maxNum && index != str.count - 1 {
          maxNum = num
          secondNum = 0
        } else if num > secondNum {
          secondNum = num
        }
      }
      return UInt64(Int(result) + maxNum * 10 + secondNum)
    }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> UInt64 {
    guard let entity = entities.first else { return 0 }
    let answer: UInt64 = entity.reduce(0) { result, str in
      var leftBound = 0
      var temporaryResult: UInt64 = 0
      for i in (0...11).reversed() {
        let base = Int(pow(10.0, Double(i)))
        let subStr = String(str.dropLast(i).dropFirst(leftBound))
        let maxChar = subStr.max()!
        leftBound = (str.dropFirst(leftBound).firstIndex(of: maxChar)?.utf16Offset(in: str) ?? 0) + 1
        temporaryResult += UInt64(String(maxChar))! * UInt64(base)
      }
      return result + temporaryResult
    }
    return answer
  }
}
