import ArgumentParser

// Add each new day implementation to this array:
let allChallenges: [any AdventDay] = [
  Day00(),
  Day01(),
  Day02(),
  Day03(),
  Day04(),
  Day05(),
  Day06(),
  Day07(),
  Day08(),
  Day09(),
  Day10(),
  Day11(),
  Day12(),
]

@main
struct AdventOfCode: AsyncParsableCommand {
  @Argument(help: "The day of the challenge. For December 1st, use '1'.")
  var day: Int?

  @Flag(help: "Benchmark the time taken by the solution")
  var benchmark: Bool = false

  @Flag(help: "Run all the days available")
  var all: Bool = false

  /// The selected day, or the latest day if no selection is provided.
  var selectedChallenge: any AdventDay {
    get throws {
      if let day {
        if let challenge = allChallenges.first(where: { $0.day == day }) {
          return challenge
        } else {
          throw ValidationError("No solution found for day \(day)")
        }
      } else {
        return latestChallenge
      }
    }
  }

  /// The latest challenge in `allChallenges`.
  var latestChallenge: any AdventDay {
    allChallenges.max(by: { $0.day < $1.day })!
  }

  @discardableResult
  func run<T>(part: () async throws -> T, named: String) async -> (Duration, Bool) {
    if T.self == Any.self {
      print("\(named): Unimplemented")
      return (.zero, false)
    }

    var result: Result<T, Error>?
    let timing = await ContinuousClock().measure {
      do {
        result = .success(try await part())
      } catch {
        result = .failure(error)
      }
    }
    switch result! {
    case .success(let success):
      print("\(named): \(success)")
      return (timing, true)
    case .failure(let failure as PartUnimplemented):
      print("Day \(failure.day) part \(failure.part) unimplemented")
      return (timing, false)
    case .failure(let failure):
      print("\(named): Failed with error: \(failure)")
      return (timing, false)
    }
  }

  func run() async throws {
    let challenges =
      if all {
        allChallenges
      } else {
        try [selectedChallenge]
      }

    for challenge in challenges {
      await runChallenge(challenge)
    }
  }

  func runChallenge(_ challenge: some AdventDay) async {
    print("Executing Advent of Code challenge \(challenge.day)...")

    let (timing1, part1Implemented) = await run(part: challenge.part1, named: "Part 1")
    var timing2: Duration = .zero

    if part1Implemented {
      let (t2, _) = await run(part: challenge.part2, named: "Part 2")
      timing2 = t2
    }

    if benchmark {
      print("Part 1 took \(timing1), part 2 took \(timing2).")
      #if DEBUG
        print("Looks like you're benchmarking debug code. Try swift run -c release")
      #endif
    }
  }
}
