/*:
# Sentiment analysis using function composition

Below is a rudimentary sentiment analysis implementation.
The algorithm works by comparing each word of a **String** with a **Set** of positive words and a **Set** of negative words.
Each negative word has a value of **-1**, each positive word **+1**.
The final rating of a String is calculated by adding together the value of all the negative and positive words.
As a final touch, an emoji **String** is displayed to represent the sentiment of the input **String**.

The most interesting aspect of the code is the way the algorithm is built up by composing smaller functions together.
*/
import Foundation
/*: 
**Compose function forwards**

The compose operator takes two functions as arguments (**A -> B**) & (**B -> C**) and returns a function (**A -> C**).
This operator can be used to thread together a chain of functions. In Haskell, function composition is from right to left.
In Swift it seems more natural to compose from left to right, hence the decision to use a chunky **dot** operator with
a right pointing arrow **•>**
*/
infix operator •> {associativity right precedence 170}
func •> <A,B,C>(f:A -> B, g:B -> C) -> A -> C {
  return { x in g(f(x)) }
}
/*:
### **Implementation**

There are several tasks that need taking care of.
An input **String** needs to be converted to lowercase, then split into an **Array** of **Strings**.
The **Sets** of positive and negative words will contain lowercase **Strings**, hence the need to convert the input **String** to lowercase.

* * *

A **NSCharacterSet** which is a combination of **whitespaceAndNewlineCharacterSet** & **punctuationCharacterSet**.
This will be used to split strings into an **Array** of words.
*/
let splitCharacterSet: NSCharacterSet = {
  let chars = NSMutableCharacterSet.whitespaceAndNewlineCharacterSet()
  chars.formUnionWithCharacterSet(NSCharacterSet.punctuationCharacterSet())
  return chars.copy() as! NSCharacterSet
}()
/*:
The **positiveWords** & **negativeWords** are loaded from files.
The files can be found in the *Resources* folder the **wordSetFromFile** function is defined in the *Sources* folder.
*/
let positiveWords: Set<String> = wordSetFromFile("positive-words")
let negativeWords: Set<String> = wordSetFromFile("negative-words")
//: **lowercaseString** method wrapped in a function to allow function composition.
func toLowercase(s:String) -> String {
  return s.lowercaseString
}
//: Split a **String** into words, filtering out empty strings
func words(str:String) -> [String] {
  return str.componentsSeparatedByCharactersInSet(splitCharacterSet).filter { !$0.isEmpty }
}

typealias Rating = Int
//: Positive words are given a rating of **1**, negative **-1**, neutral **0**.
func rateWord(word:String) -> Rating {
  if positiveWords.contains(word) { return 1 }
  if negativeWords.contains(word) { return -1 }
  return 0
}

//: Apply the **rateWord** function to each word in an **Array**, accumulating the result
func rateWords(words:[String]) -> Rating {
  return reduce(words, 0) { rating, word in rating + rateWord(word) }
}
/*: 
Show an appropriate number of emoji for the **Rating**.

  -2 == 😱😱

   3 == 😀😀😀

   0 == 😶
*/
func ratingDescription(r:Rating) -> String {
  switch r {
  case Int.min..<0: return reduce(1...abs(r), "") { str, _ in str + "😱" }
  case 1..<Int.max: return reduce(1...r, "") { str, _ in str + "😀" }
  default: return "😶"
  }
}
/*:
# **Function composition**

With all the pieces in place the rating function can now be defined.
Simply compose together the separate functions using the forward compose operator **•>**

The first thing to do is **downcase** the input string, followed by splitting it into **Words**,
**reduce** is then used to accumulate a **Rating** using the **rateWord** function.
Finally, convert the result into a descriptive emoji string using the **ratingDescription** function.
*/
let rateString = toLowercase
              •> words
              •> rateWords
              •> ratingDescription
/*:
## **Time to test the function**
*/
rateString("Happy, happy, joy, joy!")

rateString("It was the best of times, it was the worst of times")

rateString("The horror! The horror!")

/*:
### **Rate some files**

The text files can be found in the *Resources* folder.
The **stringFromFile** function is defined in the *Sources* folder.
It returns an **Optional<String>**, hence the use of the <*> operator to call **rateString**.

* * *

map for Optional as an infix operator
*/
infix operator <*> { associativity left }
func <*> <A,B>(x:A?, f:A -> B) -> B? {
return map(x, f)
}

stringFromFile("naked_lunch_extract") <*> rateString

stringFromFile("paradise_lost_extract") <*> rateString

stringFromFile("the_hollowmen") <*> rateString

stringFromFile("doors_of_perception_extract") <*> rateString

stringFromFile("once_in_a_lifetime") <*> rateString

stringFromFile("John_chapter1") <*> rateString

/*:
The results have looked reasonable so far, but it's not too difficult to demonstrate the inadequacy of the algorithm.
The Joy Division song, "Love will tear us apart", is notoriously miserable. Let's rate it:
*/
stringFromFile("love_will_tear_us_apart") <*> rateString

/*:
Who'd have realized, it's actually a very jolly song?

## **Conclusion**

As the final result shows, this isn't the most sophisticated example of a sentiment analysis algorithm.
However the real purpose of this Playground is to demonstrate the following points:

- An algorithm can be broken down into discreet steps.
- Each step can be implemented as a function that takes an argument and returns a value.
- Once all the individual pieces have been implemented, they can be composed together to create the final algorithm.
- The advantage of this approach is that each individual component can be tested separately and can also be reused for other purposes.
*/
