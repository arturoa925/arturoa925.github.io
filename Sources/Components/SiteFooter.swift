import Foundation
import Ignite

struct SiteFooter: HTML {
    var body: some HTML {
        Section {
            Divider()

            HStack {
                Link(target: "https://github.com/arturoa925") {
                    Image(systemName: "github", description: "GitHub")
                }
                .target(.blank)
                .relationship(.noOpener, .noReferrer)

                Link(target: "https://www.linkedin.com/in/arturo-ayala-775493187") {
                    Image(systemName: "linkedin", description: "LinkedIn")
                }
                .target(.blank)
                .relationship(.noOpener, .noReferrer)

                Link(target: "mailto:ayalaarturo925@gmail.com") {
                    Image(systemName: "envelope", description: "Email")
                }
            }
            .horizontalAlignment(.center)
            .font(.title4)
            .margin(.top, .medium)

            Text("Built in Swift with Ignite.")
                .font(.small)
                .foregroundStyle(.secondary)
                .margin(.top, .small)
        }
        .horizontalAlignment(.center)
        .padding(.vertical, .xLarge)
    }
}
