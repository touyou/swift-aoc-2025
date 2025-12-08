import Foundation

extension String {
  subscript(i: Int) -> String {
    String(dropFirst(i).prefix(1))
  }
}
