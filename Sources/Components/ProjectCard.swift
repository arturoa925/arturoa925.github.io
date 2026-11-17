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

    /// A screenshot for the project's row, plus an optional dark-mode version.
    var thumb: String? { metadata["thumb"] as? String }
    var thumbDark: String? { metadata["thumbDark"] as? String }

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
            .class("entry-text")

            if let thumb = project.thumb {
                Link(target: project.path) {
                    Image(thumb, description: "\(project.title) screenshot")
                        .class(project.thumbDark == nil ? "thumb" : "thumb thumb-light")
                    if let dark = project.thumbDark {
                        Image(dark, description: "\(project.title) screenshot")
                            .class("thumb thumb-dark")
                    }
                }
                .class("entry-thumb")
            }
        }
        .class(project.thumb == nil ? "entry" : "entry work")
    }
}

/// One post in the log: date on the left, title and summary beside it.
struct PostRow: HTML {
    let post: Article

    var body: some HTML {
        Section {
            Text(post.displayDate)
                .class("entry-side")

            Text {
                Link(post.title, target: post.path)
                    .class("entry-title")
            }

            Text(post.summary)
                .class("entry-summary")
        }
        .class("entry")
        .attribute("data-tags", (post.tags ?? []).joined(separator: ","))
    }
}
