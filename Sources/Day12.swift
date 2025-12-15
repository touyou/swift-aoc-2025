import Algorithms

struct Day12: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[String]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "\n").compactMap { String($0) }
    }
  }

  func part1() -> Int {
    let problems = entities.last ?? []
    let baseShapes = entities.dropLast().map { region in
      var b: UInt16 = 0
      for (y, rawRow) in region.dropFirst().enumerated() {
        let row = rawRow.trimmingCharacters(in: .whitespacesAndNewlines)
        for (x, ch) in row.enumerated() {
          if ch == "#" {
            let idx = y * 3 + x
            b |= (1 << idx)
          }
        }
      }
      return b
    }

    return 0
  }

  func part2() -> Any {
    0
  }
}
