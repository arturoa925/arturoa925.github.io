import Foundation
import Ignite

struct About: StaticPage {
    var title = "About | Arturo Ayala"
    var description = "About Arturo Ayala, software developer."
    var image: URL? = PortfolioSite.shareImage

    var body: some HTML {
        Section {
            Image("/images/arturo.jpg", description: "Arturo Ayala, smiling, outdoors in a white cap and black T-shirt")
                .class("portrait")

            Text("About")
                .font(.title1)

            Text("I build native iOS and watchOS apps in Swift and SwiftUI, and full-stack apps in JavaScript and React. My focus is state-driven UI, clean data flow, and architecture that stays readable as an app grows.")
                .class("lead")
        }
        .class("page-head", "about-head")

        Section {
            Text("Recent work")
                .font(.title2)
            Text("A Siri-driven daily planner built on App Intents and SwiftData. An iPhone and Apple Watch strength tracker synced with WatchConnectivity. A street-level map that reacts to weather and time of day. A full-stack React Native training app with its own Node.js and PostgreSQL backend.")

            Text("How I work")
                .font(.title2)
            Text("I map screens and data flow before I write code, trace problems by hand, and test on real devices in real conditions.")

            Text("Stack")
                .font(.title2)
            Text("Swift, SwiftUI, SwiftData, App Intents, watchOS, Swift Concurrency, JavaScript, TypeScript, React, React Native, Expo, Node.js, Express, PostgreSQL, Git.")

            Text("Background")
                .font(.title2)
            Text("Technical Specialist at Apple. UC Berkeley Full Stack Web Development Bootcamp, 2024. Bilingual in English and Spanish.")

            Text(markdown: "[Résumé](/resume), [GitHub](https://github.com/arturoa925), [LinkedIn](https://www.linkedin.com/in/arturo-ayala-775493187), [Email](mailto:ayalaarturo925@gmail.com)")
                .margin(.top, .large)
        }
        .class("prose", "about-section")
    }
}
