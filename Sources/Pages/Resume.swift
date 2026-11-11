import Foundation
import Ignite

/// One role or project on the résumé.
struct ResumeEntry {
    let title: String
    let detail: String
    let dates: String
    let bullets: [String]
}

struct Resume: StaticPage {
    var title = "Résumé | Arturo Ayala"
    var description = "Arturo Ayala's résumé: iOS and full-stack software developer."
    var image: URL? = PortfolioSite.shareImage

    static let pdfPath = "/files/arturo-ayala-resume.pdf"

    let skills: [(String, String)] = [
        ("Languages", "Swift, TypeScript, JavaScript, HTML/CSS"),
        ("Apple platforms", "SwiftUI, SwiftData, App Intents, WatchConnectivity, Core Location, CoreMotion, UserNotifications, Swift Concurrency, watchOS"),
        ("Web & mobile", "React, React Native, Expo, Node.js, Express, Sequelize, PostgreSQL, REST APIs, JWT/OAuth, OpenAI API"),
        ("Testing & quality", "Swift Testing, XCTest/XCUITest, VoiceOver and accessibility, MVVM"),
        ("Tools", "Xcode, Git/GitHub, Figma, Postman, Terminal, Claude Code"),
    ]

    let projects: [ResumeEntry] = [
        ResumeEntry(
            title: "Launch Control",
            detail: "iOS daily planner · Swift, SwiftUI, SwiftData, App Intents",
            dates: "github.com/arturoa925/Daily-Protocol",
            bullets: [
                "Built a three-screen planner with swipe-to-complete events, streaks, reminders, and weekly and monthly completion charts.",
                "Exposed events to Siri and Shortcuts with App Intents, sharing one SwiftData store across the app, intents and notification actions through an App Group.",
                "Resolved Swift 6 strict-concurrency errors by isolating container creation in an actor; added self-healing persistence that falls back instead of crashing.",
                "Covered logic with Swift Testing and the main flows with XCUITest; full VoiceOver support and Reduce Motion.",
            ]
        ),
        ResumeEntry(
            title: "Axis",
            detail: "iPhone + Apple Watch strength tracker · SwiftUI, SwiftData, WatchConnectivity",
            dates: "github.com/arturoa925/Axis",
            bullets: [
                "Plan routines on iPhone from a 141-exercise library, run them set by set on Apple Watch, and review history on the phone.",
                "Designed the sync around lightweight Codable payloads: application context for routines, and sendMessage with a transferUserInfo fallback so finished workouts are never lost.",
                "Wrote about 100 Swift Testing tests across the iPhone and Watch targets.",
            ]
        ),
        ResumeEntry(
            title: "FITNESS",
            detail: "Full-stack training app · React Native, Expo, Node.js, Express, PostgreSQL",
            dates: "github.com/arturoa925/FITNESS-client · FITNESS-server",
            bullets: [
                "Built an offline-first client that queues writes locally and replays them when connectivity returns.",
                "Designed a REST API with Sequelize on PostgreSQL, bcrypt and JWT auth, Google and GitHub OAuth, and rate-limited login.",
                "Added AI-generated daily workouts through the OpenAI API with strict JSON validation and a graceful fallback.",
            ]
        ),
        ResumeEntry(
            title: "Drift (in progress)",
            detail: "Street-level map experience · SwiftUI Canvas, Core Location, CoreMotion",
            dates: "github.com/arturoa925/Drift",
            bullets: [
                "Directed an AI-built app from a written design spec: a weather- and time-reactive theme engine and a custom street-level renderer using OpenStreetMap data.",
            ]
        ),
    ]

    let experience: [ResumeEntry] = [
        ResumeEntry(
            title: "Technical Specialist",
            detail: "Apple",
            dates: "Jan 2026 – Present",
            bullets: [
                "Diagnose and resolve hardware and software issues across iPhone, iPad and Apple Watch in a high-volume store, averaging about 4 appointments an hour at peak.",
                "Introduced a check-in practice of thorough notes and up-front diagnostics that saves at least 5 minutes per case; other staff have adopted it.",
                "Mentor newly promoted technicians through complex account-recovery and repair-eligibility cases.",
            ]
        ),
        ResumeEntry(
            title: "Product Specialist",
            detail: "Apple",
            dates: "Aug 2025 – Jan 2026",
            bullets: ["Guided customers through product selection, setup and troubleshooting; promoted within five months."]
        ),
        ResumeEntry(
            title: "Educator",
            detail: "Lululemon",
            dates: "2023 – 2025",
            bullets: [
                "Matched customers with the right gear for their workouts, training and lifestyle through needs-based product education.",
                "Handled point-of-sale transactions, stock management and floor replenishment while contributing to store sales goals.",
            ]
        ),
        ResumeEntry(
            title: "Shift Supervisor",
            detail: "Peet's Coffee & Tea",
            dates: "2023",
            bullets: ["Led shifts for a team of about 20: role delegation, cash, inventory counts, sales tracking across four channels, and next-day supply orders."]
        ),
        ResumeEntry(
            title: "Shift Supervisor",
            detail: "Starbucks",
            dates: "2021 – 2023",
            bullets: ["Ran shifts at a high-volume store with a team of about 30, handling delegation, cash, inventory and daily supply ordering."]
        ),
    ]

    let education = [
        "UC Berkeley Full Stack Web Development Bootcamp — 2024",
        "Meta iOS Developer Professional Certificate — 2025",
        "Codecademy: iOS Engineering, Full Stack Engineer",
        "Business and economics coursework — University of San Francisco; Arizona State University",
        "Bilingual: English and Spanish",
    ]

    var body: some HTML {
        Section {
            Section {
                Text("Résumé")
                    .font(.title1)
                Text("Software developer, iOS and full-stack. San Francisco Bay Area.")
                    .class("lead")
            }

            Link("Download PDF", target: Self.pdfPath)
                .linkStyle(.button)
                .role(.primary)
                .target(.blank)
        }
        .class("resume-head")

        Section {
            Text(markdown: "[ayalaarturo925@gmail.com](mailto:ayalaarturo925@gmail.com), [GitHub](https://github.com/arturoa925), [LinkedIn](https://www.linkedin.com/in/arturo-ayala-775493187)")
                .class("meta")

            Text("Software developer who builds native iOS and watchOS apps in Swift and SwiftUI, and full-stack apps in TypeScript, React and React Native. Focused on state-driven UI, clean data flow, and architecture that stays readable as an app grows.")
                .margin(.top, .medium)

            Text("Technical skills")
                .font(.title2)
            Section {
                ForEach(skills) { skill in
                    Text(markdown: "**\(skill.0):** \(skill.1)")
                }
            }
            .class("skills")

            Text("Projects")
                .font(.title2)
            ForEach(projects) { entry in
                entryView(entry)
            }

            Text("Experience")
                .font(.title2)
            ForEach(experience) { entry in
                entryView(entry)
            }

            Text("Education and certifications")
                .font(.title2)
            List(education) { line in
                ListItem { line }
            }
            .listMarkerStyle(.unordered(.automatic))
        }
        .class("resume")
        .margin(.bottom, .xLarge)
    }

    private func entryView(_ entry: ResumeEntry) -> some HTML {
        Section {
            Text {
                Strong(entry.title)
                Span(entry.dates)
                    .class("when")
            }
            .class("job-head")

            Text(entry.detail)
                .class("job-detail")

            List(entry.bullets) { bullet in
                ListItem { bullet }
            }
            .listMarkerStyle(.unordered(.automatic))
        }
        .class("job")
    }
}
