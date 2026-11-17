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

    /// Plain text of every element with this tag in the post body, in order.
    private func plainTexts(of tag: String) -> [String] {
        var found: [String] = []
        var rest = Substring(text)
        while let open = rest.range(of: "<\(tag)"),
              let start = rest.range(of: ">", range: open.upperBound..<rest.endIndex),
              let close = rest.range(of: "</\(tag)>", range: start.upperBound..<rest.endIndex) {
            let plain = rest[start.upperBound..<close.lowerBound]
                .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if !plain.isEmpty { found.append(plain) }
            rest = rest[close.upperBound...]
        }
        return found
    }

    /// The post's opening paragraph for the hover preview. One that leads into
    /// a list ends in a colon, so it trails off instead.
    var excerpt: String {
        var line = plainTexts(of: "p").first ?? ""
        if line.hasSuffix(":") { line = String(line.dropLast()) + "…" }
        guard line.count > 200 else { return line }
        let cut = line.prefix(200)
        return (cut.range(of: " ", options: .backwards).map { String(cut[..<$0.lowerBound]) } ?? String(cut)) + "…"
    }

    /// The post's section headings, shown as an outline in the hover preview.
    var outline: [String] {
        Array(plainTexts(of: "h2").prefix(5))
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
        .attribute("data-preview", post.excerpt)
        .attribute("data-minutes", "\(post.estimatedReadingMinutes) min read")
        .attribute("data-outline", post.outline.joined(separator: "|"))
    }
}
