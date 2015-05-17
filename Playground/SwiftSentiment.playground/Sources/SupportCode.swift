import Foundation

public func wordSetFromFile(file:String) -> Set<String> {
  let text = stringFromFile(file)!
  let words = split(text) { $0 == "\n" }
  return Set(words)
}

public func stringFromFile(file:String) -> String? {
  return NSBundle.mainBundle().pathForResource(file, ofType: "txt").map { path in
    String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
  }
}