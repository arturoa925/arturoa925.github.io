---
layout: PostPage
date: 2026-11-04 09:00
tags: Swift, DSA
description: In Swift, string.count isn't free. Here's why a loop that calls it can quietly go from O(n) to O(n²).
---
# The hidden cost of string.count in Swift

Here's a quick self-test: you write a loop over `n` items, and inside it you call `string.count`. What's the Big O?

If you said O(n), you're thinking of `count` as a stored number. In a lot of languages it is. In Swift, on a `String`, it isn't.

## Why count is O(n) on a String

A Swift `String` is a collection of `Character`s, and a `Character` is an **extended grapheme cluster**: what a person sees as one character. "é" can be one Unicode scalar or two (an "e" plus a combining accent). A flag emoji is two scalars. A family emoji can be seven.

Because characters have different sizes, Swift can't jump straight to the 500th character or know the total without walking the string. So `String` is a `BidirectionalCollection`, not a `RandomAccessCollection`, and `count` has to step through every character. That makes it **O(m)**, where m is the length of the string.

## What that does to your loop

```swift
// Looks harmless
var i = 0
while i < text.count {      // count is recalculated on every check
    // ...
    i += 1
}
```

`text.count` runs once per iteration, and each call walks the whole string. That's O(m) work done m times: **O(m²)**. The same thing happens if you index with `text.index(text.startIndex, offsetBy: i)` inside the loop, since each offset also walks from the start.

If you loop over `n` items and call `count` on a separate string of length `m` each time, it's **O(n · m)**.

## The fixes

**Hoist it.** Compute the count once, outside the loop.

```swift
let length = text.count
for i in 0..<length { /* ... */ }
```

A `for i in 0..<text.count` loop is actually fine, because the range is built once. The trap is the `while` condition that re-evaluates.

**Iterate directly.** If you only need each character, skip the index math.

```swift
for character in text { /* ... */ }
```

**Convert once when you need random access.** For problems that compare positions, like two pointers or palindromes, pay O(m) once and get O(1) indexing after that.

```swift
let chars = Array(text)
var left = 0, right = chars.count - 1
while left < right, chars[left] == chars[right] {
    left += 1
    right -= 1
}
```

**Check emptiness with `isEmpty`.** `text.isEmpty` is O(1). `text.count == 0` walks the whole string.

## Takeaway

Big O isn't only about the loops you write. It's also about the cost of every call inside them. When I trace a problem by hand now, I ask what each call costs, not just how many times the loop runs.
