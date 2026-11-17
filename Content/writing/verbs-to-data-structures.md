---
image: https://arturoa925.github.io/images/og.png
layout: PostPage
date: 2026-10-31 09:00
tags: DSA, Swift
description: Rewrite the problem in plain words and circle the verbs. They usually point straight at the right data structure.
---
# Circle the verbs: picking a data structure from the problem statement

Before I write a line of code, I rewrite the problem in plain words and **circle the verbs**. The verbs usually point straight at the structure I need.

<figure class="board verbs" aria-label="A problem statement with the verbs count and top k circled, each pointing to the data structure it suggests">
<p class="board-title">problem statement</p>
<p class="wire statement">Given a list of words, <span class="circled">count</span> how many times each one appears and return the <span class="circled">top k</span> most frequent.</p>
<div class="verb-map">
<div class="verb-col"><span class="down-arrow" aria-hidden="true"></span><div class="wire loop-box"><strong>dictionary of counts</strong><span><code>[String: Int]</code>, one pass, O(n)</span></div></div>
<div class="verb-col"><span class="down-arrow" aria-hidden="true"></span><div class="wire loop-box"><strong>heap of size k</strong><span>keep only the best k, O(n log k)</span></div><ul class="sticky"><li>only need the best few? don't sort everything</li></ul></div>
</div>
<figcaption>Two verbs, two structures. The dictionary answers "how many," the heap answers "which are the top k."</figcaption>
</figure>

Here's my cheat sheet, with what each looks like in Swift.

## "Find" / "have I seen this?" → Set or Dictionary

Constant-time lookup instead of scanning.

```swift
var seen = Set<Int>()
for n in nums {
    if seen.contains(target - n) { return true }
    seen.insert(n)
}
```

If the input is **sorted**, "find" can also mean **binary search**: O(log n) with no extra memory.

## "Order" / "sort by" → Sorting

Many problems get easier once the data is in order: intervals, meetings, closest pairs.

```swift
let sorted = intervals.sorted { $0.start < $1.start }
```

## "Undo" / "most recent" / "matching pairs" → Stack

Last in, first out. Undo history, valid parentheses, and backtracking all use this shape.

```swift
var stack: [Character] = []
let pairs: [Character: Character] = [")": "(", "]": "[", "}": "{"]
for c in s {
    if let open = pairs[c] {
        guard stack.popLast() == open else { return false }
    } else {
        stack.append(c)
    }
}
return stack.isEmpty
```

## "Connect" / "reachable" / "groups" → Graph (BFS, DFS, union-find)

If things link to other things, it's a graph, even when the problem calls it a grid, a network or friends.

```swift
var queue = [start]
var visited: Set = [start]
while !queue.isEmpty {
    let node = queue.removeFirst()
    for next in neighbors[node, default: []] where !visited.contains(next) {
        visited.insert(next)
        queue.append(next)
    }
}
```

(For large inputs, keep a head index instead of `removeFirst()`, which is O(n) on an array.)

## "Rank" / "top k" / "closest" → Heap

When you only need the best few, don't sort everything. Keep a heap of size k. Swift's standard library doesn't include one, so I use `Heap` from the swift-collections package or write a small one.

## "Count" / "how many" → Dictionary of counts

```swift
let counts = words.reduce(into: [String: Int]()) { $0[$1, default: 0] += 1 }
```

## Why this works

Problem statements are written in plain language on purpose. The verbs describe the operations you'll do most often, and data structures exist to make specific operations cheap. Matching them up is most of the work.

It doesn't always work on the first try. But it gives me a strong first guess before I start tracing.
