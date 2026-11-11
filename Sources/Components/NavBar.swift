import Foundation
import Ignite

struct NavBar: HTML {
    var body: some HTML {
        NavigationBar {
            Link("Projects", target: Projects())
            Link("Writing", target: Writing())
            Link("Résumé", target: Resume())
            Link("About", target: About())
        } logo: {
            Span("Arturo Ayala")
                .fontWeight(.semibold)
        }
        .navigationItemAlignment(.trailing)
        .navigationBarStyle(.light)
        .background(.white)
        .position(.fixedTop)
    }
}
