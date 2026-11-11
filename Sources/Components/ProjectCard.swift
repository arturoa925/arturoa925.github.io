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

    /// A short stack line from front matter, e.g. "Swift · SwiftUI · SwiftData".
    var stack: String? {
        metadata["stack"] as? String
    }

    /// Front-matter `description` wins over Ignite's auto-generated first paragraph.
    var summary: String {
        (metadata["description"] as? String) ?? description
    }

    var displayDate: String {
        date.formatted(.dateTime.month(.abbreviated).day().year())
    }
}

struct ProjectCard: HTML {
    let project: Article

    var body: some HTML {
        Card {
            Text(project.subtitle ?? project.description)

            if let stack = project.stack {
                Text(stack)
                    .font(.small)
                    .foregroundStyle(.secondary)
            }

            Link("Read the case study →", target: project.path)
        } header: {
            Text(project.title)
                .font(.title4)
                .fontWeight(.semibold)
        }
        .frame(height: .percent(100%))
    }
}

struct PostRow: HTML {
    let post: Article

    var body: some HTML {
        Section {
            Link(post.title, target: post.path)
                .font(.title5)
                .fontWeight(.semibold)

            Text(post.summary)
                .foregroundStyle(.secondary)
                .margin(.vertical, .xSmall)

            Text {
                post.displayDate
                " · \(post.estimatedReadingMinutes) min read"
                if let tags = post.tags, tags.isEmpty == false {
                    " · " + tags.joined(separator: ", ")
                }
            }
            .font(.small)
            .foregroundStyle(.tertiary)
        }
        .padding(.vertical, .medium)
    }
}
