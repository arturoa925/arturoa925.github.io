---
image: https://arturoa925.github.io/images/og.png
layout: PostPage
date: 2026-11-27 09:00
tags: Process, Swift
description: Why I give each agent one job, let the slow work run in the background, and keep the architecture and algorithm calls for myself.
---
# A Crock-Pot, not a microwave

My AI setup is a Crock-Pot, not a microwave.

A microwave is one chatbot doing everything. It's fast, but the results come out mediocre. A Crock-Pot does the slow work in the background while I go about my day. I come back, finish it off, and adjust the seasoning myself.

That's how my agents work. Each one has one job, whether that's design, code, job search, the portfolio, or media, and none of them overlap. They do the heavy lifting. I make the final calls.

I used to be against AI assistance. I use it every day now, with the same rule as in [Arguing with your AI](/writing/arguing-with-ai): **AI speeds up the typing. I make the decisions.** Architecture and algorithm choices stay with me. Boilerplate, debugging, tests, and UI changes are fair game. The Crock-Pot is how that rule still holds once the work is bigger than one prompt.

## Why one chatbot comes out mediocre

One chatbot with every job in the same thread breaks a rule I already follow in SwiftUI. A view renders state. A model loads and holds the data. A client talks to the network. I keep them apart because a type with two jobs has two reasons to change. Fix the request and the layout code gets touched with it. Restyle a row and the call site gets rewritten too.

```text
SwiftUI view     renders state
Model            loads and holds the data
API client       talks to the network
```

A single chat fails the same way, with words instead of types. Design wants a few options. Code wants one structure and a reason for it. A job draft has to describe work the repos actually contain. A sentence on this site has to match those repos. A short post wants one claim. Put all of that in one context and the model averages them. The reply is fast, and every job comes back a little wrong.

Speed was never the problem. One shared context was. One agent, one job. If the output starts doing a second job, I treat it the way I treat networking code inside a view: the boundary slipped, and the work goes back.

The same split, with no app around it. `ItemAPI.fetch()` is a stand-in so the example runs. It is not a client from one of my projects.

```swift
struct Item: Equatable {
    var title: String
}

enum ItemAPI {
    static func fetch() async throws -> [Item] {
        [Item(title: "Row")]
    }
}

struct CoupledList {
    var rows: [String] = []

    // Fetching and presenting live together, so one change rewrites both.
    mutating func loadAndPresent() async throws {
        let items = try await ItemAPI.fetch()
        rows = items.map(\.title)
    }
}

struct ItemListModel {
    private(set) var items: [Item] = []

    mutating func load() async throws {
        items = try await ItemAPI.fetch()
    }
}

struct ItemListView {
    func rows(from model: ItemListModel) -> [String] {
        model.items.map(\.title)
    }
}
```

`CoupledList` is the microwave. The view only asks for rows. The model is the only type allowed to load.

## One agent, one job

The name is the job. If I can't say it in a few words, the agent is already too big. The run only gets the context that job needs. [Drift](/projects/drift) already does this for one effort: `claude.md` gives the model the concept, the feel, and the build order at the start of a session. These agents are that same limit, split by job, so a run is never handed every other task I have open.

**Design** works on screens, layout, and how a flow should feel. It gets who it's for, what they see, and what has to come back. It does not write the implementation or choose the data model. A layout that quietly picks an architecture starts defending a structure I haven't chosen.

**Code Master** writes code once that structure is chosen: boilerplate, tests, debugging, and UI changes that follow a design I already accepted. When something is broken, it gets what I expected, what happened, and where I think it starts. It does not get "build me an app," and it does not pick the architecture or the algorithm. If the draft also invented the plan, I can't separate a bad line from a bad decision.

In [Launch Control](/projects/launch-control) and [Axis](/projects/axis), I write the code and bring an agent in for tests, bugs, and UI tweaks. Drift runs the other way: I set the concept, the spec, and the build order, and the implementation was prompted. I still reviewed every change on a real device. Who decides does not change.

**Job Hunter** stays on the job search. It gets the public projects and the role in front of it, and it can gather and draft. It does not decide which roles are a fit, and it does not describe a project the repo doesn't support. I keep the final wording so the description matches the work.

**Portfolio Bot** works on this site. It gets the page and the repo that page has to match. It can draft. It does not ship. A sentence I can't explain doesn't go up, which is the same bar I use before I [accept a fix](/writing/using-claude-to-fix-my-own-apps).

**Media bot** drafts the short public version of a claim I already settled. It does not add claims, and it does not decide that something is ready to post. The short version is the hook. A page like this one is the full version, so the hook can't grow a claim the page doesn't support.

None of them share a job. Design doesn't fix the code on the way through. Code Master doesn't rewrite the post. Media bot doesn't turn the hook into the essay.

```text
Design           screens and layout
Code Master      implementation, tests, bugs, UI changes
Job Hunter       roles and drafts
Portfolio Bot    this site
Media bot        the short public version
```

## What I come back to

I start the job and leave it. The slow part is reading a codebase, trying a layout, scaffolding tests, chasing a bug, or drafting a paragraph again. I come back when there's something to finish, not when the first answer appears.

A draft is not done. Finishing is mine, for code and for words.

1. **I read it until I can explain it.** The diff, or every claim. If I can't say what changed and why, it isn't ready.
2. **I look for a second job.** A code change that also redesigns the screen, a claim I didn't make, a sentence the repo doesn't support. Those get cut.
3. **I adjust the seasoning.** The structure I actually want, the algorithm, the sentence that doesn't sound like me, the case the draft skipped.
4. **I check it where it runs.** A compile is not a test. I run code myself, on a device when the behavior is visual or depends on the real phone, and I try more than the easy path. Anything else has to match its source: the repo, the screen, or the decision I already made.

Reading comes before adjusting. For code, these are the same checks I already use when Claude proposes a fix.

## What I still decide

Agents get work that already has a shape. Boilerplate, tests, debugging, and UI changes on a screen I already accepted. That work is slow to type and straightforward to review, which is why it can run in the background.

Two decisions stay with me, because they change the shape instead of filling one in.

**Architecture.** Where state lives, which type is allowed to touch the network, how the pieces talk. Get this wrong and every later diff is a patch on a bad split. The five jobs are that decision, and an agent doesn't get to redraw the lines mid-task. A view doesn't get its own `URLSession` just because the call was nearby.

**Algorithm selection.** Which structure matches the operations, whether a function takes a value or shares a reference, and what the slow step is. An agent can write the loop after that choice. The choice is the part I learn from. If I skip it, a confident wrong answer looks like a right one.

Trying a different layout is Design, and I still pick which option ships. Building the layout I already picked is Code Master. I name the job before the run. If I don't, I'm back to one chatbot.

## The risk

The lines don't matter if I stop reviewing. A finished-looking draft, one that compiles or reads smoothly or sounds like a sentence I might have written, is still an answer I haven't checked. Taking it is faster. If I only accept answers, I stop building judgment, and judgment is what makes any of this useful.

A Crock-Pot does the slow part. I still finish it. I read the result, cut what crossed a line, and change what needs changing. Then it can ship.
