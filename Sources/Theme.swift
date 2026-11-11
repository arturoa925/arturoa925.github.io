import Foundation
import Ignite

/// Shared values for both color schemes: a quiet, Apple-style palette with one blue accent.
struct PortfolioLightTheme: Theme {
    var colorScheme: ColorScheme = .light
    var accent: Color = Color(hex: "#0071E3")
    var link: Color = Color(hex: "#0066CC")
    var hoveredLink: Color = Color(hex: "#004499")
    var linkDecoration: TextDecoration = .none
    var background: Color = Color(hex: "#FFFFFF")
    var secondaryBackground: Color = Color(hex: "#F5F5F7")
    var primary: Color = Color(hex: "#1D1D1F")
    var syntaxHighlighterTheme: HighlighterTheme = .xcodeLight
}

struct PortfolioDarkTheme: Theme {
    var colorScheme: ColorScheme = .dark
    var accent: Color = Color(hex: "#2997FF")
    var link: Color = Color(hex: "#2997FF")
    var hoveredLink: Color = Color(hex: "#66B5FF")
    var linkDecoration: TextDecoration = .none
    var background: Color = Color(hex: "#000000")
    var secondaryBackground: Color = Color(hex: "#1D1D1F")
    var primary: Color = Color(hex: "#F5F5F7")
    var syntaxHighlighterTheme: HighlighterTheme = .xcodeDark
}
