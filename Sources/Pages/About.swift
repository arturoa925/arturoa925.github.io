import Foundation
import Ignite

/// One step of how I work, linked to the post that explains it.
private struct WorkStep {
    let title: String
    let detail: String
    let post: String
}

/// One line in the background log.
private struct LogLine {
    let when: String
    let title: String
    let detail: String?
}

struct About: StaticPage {
    var title = "About | Arturo Ayala"
    var description = "About Arturo Ayala: how he builds iOS, watchOS and full-stack apps, his stack and background."
    var image: URL? = PortfolioSite.shareImage

    private let steps = [
        WorkStep(title: "Map it in Figma first",
                 detail: "Wireframes, then the data loop, then \"what breaks?\" at every arrow. I open an IDE only once the data design and the visuals are done.",
                 post: "/writing/figma-first"),
        WorkStep(title: "Pick the structure from the problem",
                 detail: "Rewrite it in plain words and circle the verbs. They usually point straight at the right data structure.",
                 post: "/writing/verbs-to-data-structures"),
        WorkStep(title: "Trace it by hand",
                 detail: "Walk a small example on paper before running anything, so the model in my head matches what the program does.",
                 post: "/writing/pre-code-routine"),
        WorkStep(title: "Make failures loud",
                 detail: "No silent saves or swallowed errors. Log it, show it, and write a test that forces it.",
                 post: "/writing/silent-failures"),
        WorkStep(title: "Test where people actually are",
                 detail: "Elevators, garages, bad Wi-Fi and lost signal, not just the simulator.",
                 post: "/writing/field-testing")
    ]

    private let now: [(String, String)] = [
        ("Data structures and algorithms", "Working through the NeetCode 150 in Swift, and again in TypeScript, tracing each problem by hand before I write code."),
        ("Computer science", "Going through Stanford's free CS course materials in order, from the foundations up."),
        ("System design", "Practicing how to break a large system into parts and reason about the trade-offs between them."),
        ("Reading", "Technical books alongside the courses."),
        ("Apple platforms", "Digging into how Apple's systems work under the hood, like iCloud, Face ID and Continuity, because it changes how I design apps on top of them.")
    ]

    private let stack: [(String, String)] = [
        ("Apple platforms", "Swift, SwiftUI, SwiftData, App Intents, WatchConnectivity, Swift Concurrency, watchOS"),
        ("Web and mobile", "JavaScript, TypeScript, React, React Native, Expo, Node.js, Express, PostgreSQL"),
        ("Testing and tools", "Swift Testing, XCTest, XCUITest, VoiceOver, Xcode, Figma, Git")
    ]

    private let background = [
        LogLine(when: "2026", title: "Technical Specialist, Apple",
                detail: "Diagnose hardware and software issues across iPhone, iPad and Apple Watch."),
        LogLine(when: "2025", title: "Product Specialist, Apple",
                detail: "Promoted to Technical Specialist within five months."),
        LogLine(when: "2025", title: "Meta iOS Developer Professional Certificate", detail: nil),
        LogLine(when: "2024", title: "UC Berkeley Full Stack Web Development Bootcamp", detail: nil)
    ]

    var body: some HTML {
        Section {
            Image("/images/arturo.jpg", description: "Arturo Ayala, smiling, outdoors in a white cap and black T-shirt")
                .class("portrait")

            Section {
                Text("About")
                    .font(.title1)

                Text("I build native iOS and watchOS apps in Swift and SwiftUI, and full-stack apps in JavaScript and React. I care about state-driven UI, clean data flow, and architecture that stays readable as an app grows.")
                    .class("lead")

                Text("Technical Specialist at Apple, in the San Francisco Bay Area. Bilingual in English and Spanish.")
                    .class("about-facts")

                Section {
                    Link("Résumé", target: Resume())
                        .linkStyle(.button)
                        .role(.primary)
                    Link("GitHub", target: "https://github.com/arturoa925")
                        .linkStyle(.button)
                        .role(.secondary)
                    Link("LinkedIn", target: "https://www.linkedin.com/in/arturo-ayala-775493187")
                        .linkStyle(.button)
                        .role(.secondary)
                    Link("Email", target: "mailto:ayalaarturo925@gmail.com")
                        .linkStyle(.button)
                        .role(.secondary)
                }
                .class("actions")
            }
            .class("about-intro")
        }
        .class("about-hero")

        Section {
            Text("How I work")
                .font(.title2)
                .class("about-title")

            Section {
                ForEach(steps) { step in
                    Section {
                        Text {
                            Link(step.title, target: step.post)
                                .class("step-title")
                        }
                        Text(step.detail)
                            .class("step-detail")
                    }
                    .class("work-step")
                }
            }
            .class("work-steps")
        }
        .class("about-block")

        Section {
            Text("Now")
                .font(.title2)
                .class("about-title")

            Text("Right now, most of my time goes into foundations.")
                .class("about-note")

            Section {
                ForEach(now) { item in
                    Section {
                        Text(item.0)
                            .class("about-label")
                        Text(item.1)
                            .class("about-value")
                    }
                    .class("about-row")
                }
            }
            .class("about-rows")
        }
        .class("about-block")

        Section {
            Text("Stack")
                .font(.title2)
                .class("about-title")

            Section {
                ForEach(stack) { group in
                    Section {
                        Text(group.0)
                            .class("about-label")
                        Text(group.1)
                            .class("about-value")
                    }
                    .class("about-row")
                }
            }
            .class("about-rows")
        }
        .class("about-block")

        Section {
            Text("Background")
                .font(.title2)
                .class("about-title")

            Section {
                ForEach(background) { line in
                    Section {
                        Text(line.when)
                            .class("about-label")
                        Section {
                            Text(line.title)
                                .class("about-value", "strong")
                            if let detail = line.detail {
                                Text(detail)
                                    .class("about-detail")
                            }
                        }
                    }
                    .class("about-row")
                }
            }
            .class("about-rows")
        }
        .class("about-block")
    }
}
