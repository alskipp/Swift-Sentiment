import Foundation

public func wordSetFromFile(file:String) -> Set<String> {
  let text = stringFromFile(file)!
  let words = text.characters.split { $0 == "\n" }.map { String($0) }
  return Set(words)
}

public func stringFromFile(file:String) -> String? {
  let path = NSBundle.mainBundle().pathForResource(file, ofType: "txt")
  do { return try String(contentsOfFile: path!) }
  catch { return .None }
}
