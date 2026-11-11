import Foundation
import Ignite

extension Article {
    /// Projects set an `order` in their front matter so the most important one shows first.
    var order: Int {
        if let value = metadata["order"] as? String, let number = Int(value) {
            return number
        }
        return Int.max
    }

    /// A short stack line from front matter, e.g. "Swift, SwiftUI, SwiftData".
    var stack: String? {
        metadata["stack"] as? String
    }

    /// Where the project runs, shown on the right of its row: "iOS", "Full-stack"…
    var platform: String? {
        metadata["platform"] as? String
    }

    /// Front-matter `description` wins over Ignite's auto-generated first paragraph.
    var summary: String {
        (metadata["description"] as? String) ?? description
    }

    var displayDate: String {
        date.formatted(.dateTime.month(.abbreviated).day().year())
    }
}

/// One project in the index: name, one line, stack. Platform on the right.
struct ProjectRow: HTML {
    let project: Article

    var body: some HTML {
        Section {
            Text {
                Link(project.title, target: project.path)
                    .class("entry-title")
            }

            Text(project.platform ?? "")
                .class("entry-side")

            Text(project.subtitle ?? project.summary)
                .class("entry-summary")

            if let stack = project.stack {
                Text(stack)
                    .class("entry-meta")
            }
        }
        .class("entry")
    }
}

/// One post in the index: title and date on one line, summary under it.
struct PostRow: HTML {
    let post: Article

    var body: some HTML {
        Section {
            Text {
                Link(post.title, target: post.path)
                    .class("entry-title")
            }

            Text(post.displayDate)
                .class("entry-side")

            Text(post.summary)
                .class("entry-summary")
        }
        .class("entry")
    }
}
