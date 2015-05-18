Swift Sentiment
========

This is a demonstration of how to use function composition in Swift to construct an algorithm by composing together smaller functions. The example chosen is a very basic sentiment analysis algorithm.

The functions are combined together and used as follows:

```swift
let rateString = downCase
              •> words
              •> rateWords
              •> ratingDescription

rateString("Happy, happy, joy, joy!")
> "😀😀😀😀"

rateString("It was the best of times, it was the worst of times")
> "😶"

rateString("Now is the winter of our discontent")
> "😱"
```

Take a look at the Playground file for the full implementation and explanation.


