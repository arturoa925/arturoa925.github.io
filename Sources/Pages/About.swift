import Foundation
import Ignite

/// One step of how I work, linked to the post that explains it.
private struct WorkStep {
    let title: String
    let detail: String
    let post: String?
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
        WorkStep(title: "Research",
                 detail: "Understand the problem and what it needs before designing anything. I ask AI, ask teammates and read up.",
                 post: nil),
        WorkStep(title: "Design in Figma",
                 detail: "Wireframes, then the data loop, then \"what breaks?\" at every arrow.",
                 post: "/writing/figma-first"),
        WorkStep(title: "Code",
                 detail: "Build it, trace it by hand, and test it on real devices.",
                 post: "/writing/pre-code-routine"),
        WorkStep(title: "Research again, then code again",
                 detail: "Building turns up questions the first pass didn't. I go back, learn more, and refine.",
                 post: nil)
    ]

    private let now: [(String, String)] = [
        ("Data structures and algorithms", "Working through the NeetCode 150 in Swift, and again in TypeScript, tracing each problem by hand before I write code."),
        ("Computer science", "Going through Stanford's free CS course materials in order, from the foundations up."),
        ("System design", "Practicing how to break a large system into parts and reason about the trade-offs between them."),
        ("Reading", "Computer science books I pick from [FreeComputerBooks](https://freecomputerbooks.com/compscCategory.html), whichever topic catches my interest."),
        ("Apple platforms", "Digging into how Apple's systems work under the hood, like iCloud, Face ID and Continuity, because it changes how I design apps on top of them.")
    ]

    private let stack: [(String, String)] = [
        ("Apple platforms", "Swift, SwiftUI, SwiftData, App Intents, WatchConnectivity, Swift Concurrency, watchOS"),
        ("Web and mobile", "JavaScript, TypeScript, React, React Native, Expo, Node.js, Express, PostgreSQL"),
        ("Testing and tools", "Swift Testing, XCTest, XCUITest, VoiceOver, Xcode, Figma, Git")
    ]

    private let background = [
        LogLine(when: "2026 to now", title: "Technical Specialist, Apple",
                detail: "Diagnose hardware and software issues across iPhone, iPad and Apple Watch."),
        LogLine(when: "2025 to now", title: "Independent iOS developer",
                detail: "Design, build and test iOS, watchOS and full-stack apps end to end, from Figma to architecture to tests."),
        LogLine(when: "2025 to 2026", title: "Product Specialist, Apple",
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
                        if let post = step.post {
                            Text {
                                Link(step.title, target: post)
                                    .class("step-title")
                            }
                        } else {
                            Text(step.title)
                                .class("step-title")
                        }
                        Text(step.detail)
                            .class("step-detail")
                    }
                    .class("work-step")
                }
            }
            .class("work-steps")

            Text("The plan is a starting point. It changes as the work does.")
                .class("about-note", "after")
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
                        Text(markdown: item.1)
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
