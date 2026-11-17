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

## Why the verbs matter

A word problem is written about a story: friends, meetings, words in a document. The code doesn't care about the story. It cares about which operations run most often, because that's where the time goes. Circling the verbs is how I translate one into the other.

That translation changes how I read the problem in four ways.

**From nouns to operations.** The nouns tell me what the data *is*: words, intervals, people. The verbs tell me what I *do* with it: find, count, connect, rank. Data structures are priced by operation, not by noun. A `Set` makes "find" cheap. A heap makes "give me the best one" cheap. So the verb is the part of the sentence that maps to a cost.

**The disguise falls away.** "Friends of friends," "islands in a grid" and "courses with prerequisites" sound like three different problems. Circle the verbs and they're all "connect" or "reachable," which is a graph. Once I see the shape, I can reuse a solution I already trust instead of inventing a new one.

**Brute force gets a target.** The naive answer to "have I seen this?" is to scan the whole array every time, which turns a single pass into O(n²). Once "find" is circled, the question changes from "how do I solve this?" to "how do I make *find* cheap?" That question has a short list of answers.

**Constraints are keywords too.** "Sorted," "top k," "in place" and "at most" change the pick. "Find" in an unsorted list says `Set`. "Find" in a sorted list says binary search, with no extra memory. "Top k" says I don't need everything in order, only the best few.

It's a first guess, not a proof. Some verbs can point two ways, and the only way to know is to trace a small example by hand. But starting from the verbs means that trace has a direction.

## The cheat sheet

Here's what each verb looks like in Swift.

### "Find" / "have I seen this?" → Set or Dictionary

Constant-time lookup instead of scanning.

```swift
var seen = Set<Int>()
for n in nums {
    if seen.contains(target - n) { return true }
    seen.insert(n)
}
```

If the input is **sorted**, "find" can also mean **binary search**: O(log n) with no extra memory.

### "Order" / "sort by" → Sorting

Many problems get easier once the data is in order: intervals, meetings, closest pairs.

```swift
let sorted = intervals.sorted { $0.start < $1.start }
```

### "Undo" / "most recent" / "matching pairs" → Stack

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

### "Connect" / "reachable" / "groups" → Graph (BFS, DFS, union-find)

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

### "Rank" / "top k" / "closest" → Heap

When you only need the best few, don't sort everything. Sorting all n items costs O(n log n). A heap that never holds more than k items costs O(n log k), and k is usually small.

Swift's standard library doesn't include a heap, so I either use `Heap` from the swift-collections package or write a small one. A heap is an array where every parent outranks its children, so the top item is always at index 0:

```swift
struct Heap<Element> {
    private var items: [Element] = []
    private let isHigher: (Element, Element) -> Bool

    init(by isHigher: @escaping (Element, Element) -> Bool) {
        self.isHigher = isHigher
    }

    var count: Int { items.count }
    var top: Element? { items.first }

    mutating func push(_ element: Element) {
        items.append(element)
        var child = items.count - 1
        while child > 0 {
            let parent = (child - 1) / 2
            guard isHigher(items[child], items[parent]) else { break }
            items.swapAt(child, parent)
            child = parent
        }
    }

    @discardableResult
    mutating func pop() -> Element? {
        guard !items.isEmpty else { return nil }
        items.swapAt(0, items.count - 1)
        let removed = items.removeLast()
        var parent = 0
        while true {
            let left = 2 * parent + 1, right = left + 1
            var best = parent
            if left < items.count, isHigher(items[left], items[best]) { best = left }
            if right < items.count, isHigher(items[right], items[best]) { best = right }
            if best == parent { break }
            items.swapAt(parent, best)
            parent = best
        }
        return removed
    }
}
```

For the problem in the board above, count first, then keep a **min-heap** of size k. That sounds backwards, but it's the trick: with the weakest of the current top k on top, every new word only has to beat that one. When the heap grows past k, pop the weakest.

```swift
func topKFrequent(_ words: [String], _ k: Int) -> [String] {
    let counts = words.reduce(into: [String: Int]()) { $0[$1, default: 0] += 1 }

    // Min-heap on count: the weakest of the current top k sits on top.
    var heap = Heap<(word: String, count: Int)>(by: { $0.count < $1.count })
    for (word, count) in counts {
        heap.push((word, count))
        if heap.count > k { heap.pop() }   // drop the weakest
    }

    var result: [String] = []
    while let entry = heap.pop() { result.append(entry.word) }
    return result.reversed()               // most frequent first
}
```

`topKFrequent(["swift", "heap", "swift", "set", "heap", "swift"], 2)` returns `["swift", "heap"]`. Words with the same count come back in no particular order. If a problem asks for ties in alphabetical order, add that as a second comparison in the heap's ordering.

### "Count" / "how many" → Dictionary of counts

```swift
let counts = words.reduce(into: [String: Int]()) { $0[$1, default: 0] += 1 }
```

## Why it's worth the habit

Problem statements are written in plain language on purpose. The verbs describe the operations you'll do most often, and data structures exist to make specific operations cheap. Matching them up is most of the work, and it gives me a strong first guess before I start tracing.
