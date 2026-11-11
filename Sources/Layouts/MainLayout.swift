import Foundation
import Ignite

struct MainLayout: Layout {
    var body: some Document {
        Head {
            MetaLink(href: "/css/site.css", rel: .stylesheet)
        }

        Body {
            NavBar()
                .padding(.bottom, .xLarge)

            content
                .padding(.horizontal, .medium)
                .padding(.top, 80)

            SiteFooter()
        }
    }
}
