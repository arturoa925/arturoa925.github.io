---
image: https://arturoa925.github.io/images/og.png
layout: PostPage
date: 2026-11-03 09:00
tags: DSA, Swift, Process
description: How I solve a problem before I open the editor, and why value versus reference semantics is often half the answer.
---
# Solving a problem before I run any code

I recently solved a problem without running a single line of code until the end. Not because I'm fast. It's because of a routine I follow every time:

1. **Read the problem** all the way through, including the constraints.
2. **Redraw it in my own words.** If I can't explain it simply, I don't understand it yet.
3. **Trace one small example by hand**: a 3-element array, a 4-node tree. I write down every variable at every step.
4. **Only then open the editor.**

For that problem, the trace showed me something I would have missed in code: **which parameter was a reference** and which was a copy. That was half the answer.

## Why it matters in Swift

Swift makes the difference between value and reference types very real.

- `struct`, `enum`, `Array`, `Dictionary` and `String` are **value types**. Passing one to a function gives that function its own copy. (Swift uses copy-on-write, so the actual copy only happens if someone mutates it.)
- `class` instances are **reference types**. Pass one around and everyone shares the same object.

That changes how recursion behaves. Take backtracking, where you build a path and undo choices:

```swift
func subsets(_ nums: [Int]) -> [[Int]] {
    var result: [[Int]] = []

    func explore(_ index: Int, _ path: [Int]) {
        if index == nums.count {
            result.append(path)
            return
        }
        explore(index + 1, path + [nums[index]])  // choose
        explore(index + 1, path)                  // skip
    }

    explore(0, [])
    return result
}
```

Because `path` is a value, each call gets its own version. There's no "un-choose" step, since nothing is shared.

Now make the path a reference, or pass it `inout`, and the rules change:

```swift
func explore(_ index: Int, _ path: inout [Int]) {
    if index == nums.count {
        result.append(path)
        return
    }
    path.append(nums[index])   // choose
    explore(index + 1, &path)
    path.removeLast()          // un-choose — now required
    explore(index + 1, &path)
}
```

Forget `removeLast()` here and every branch sees the leftovers of the branches before it. The output is wrong, and nothing crashes.

## What tracing catches

When I trace by hand, I draw each variable as a box. Value types get a new box for every call. References get an arrow pointing to one shared box. The moment two arrows point at the same box, I know mutation will leak between calls, and I know whether I need an undo step.

That's the whole point of tracing first. Writing the code is the easy part once the model in my head matches what the program actually does.
