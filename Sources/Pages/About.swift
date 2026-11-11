import Foundation
import Ignite

struct About: StaticPage {
    var title = "About"
    var description = "About Arturo Ayala, software developer."

    var body: some HTML {
        Section {
            Text("About")
                .font(.title1)

            Text("I build native iOS apps in Swift and SwiftUI, and full-stack apps in TypeScript and React. My focus is state-driven UI, clean data flow, and architecture that stays readable as an app grows.")
                .font(.lead)

            Text(markdown: "**Recent work:** a Siri-driven daily planner built on App Intents and SwiftData, an iPhone and Apple Watch strength tracker synced with WatchConnectivity, a street-level map experience that reacts to weather and time of day, and a full-stack React Native training app with its own Node.js and PostgreSQL backend.")

            Text(markdown: "**How I work:** I map screens and data flow before I write code, trace problems by hand, and test on real devices in real conditions.")

            Text(markdown: "**Stack:** Swift · SwiftUI · SwiftData · App Intents · watchOS · Swift Concurrency · TypeScript · JavaScript · React · React Native/Expo · Node.js · Express · PostgreSQL · Git")

            Text(markdown: "**Background:** Technical Specialist at Apple. UC Berkeley Full Stack Bootcamp (2024). Bilingual in English and Spanish.")

            Text(markdown: "[See my résumé](/resume) · [GitHub](https://github.com/arturoa925) · [LinkedIn](https://www.linkedin.com/in/arturo-ayala-775493187) · [Email](mailto:ayalaarturo925@gmail.com)")
                .margin(.top, .large)
        }
        .frame(maxWidth: 760)
    }
}
