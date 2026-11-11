// Email links: still open the visitor's mail app, and also copy the address,
// so the click works for people who use webmail and have no mail app set up.
document.querySelectorAll('a[href^="mailto:"]').forEach(function (link) {
    link.addEventListener("click", function () {
        var address = link.getAttribute("href").replace("mailto:", "");
        if (!navigator.clipboard) return;
        navigator.clipboard.writeText(address).then(function () {
            var original = link.textContent;
            link.textContent = "Email copied";
            link.setAttribute("aria-live", "polite");
            setTimeout(function () { link.textContent = original; }, 1800);
        }).catch(function () {});
    });
});
