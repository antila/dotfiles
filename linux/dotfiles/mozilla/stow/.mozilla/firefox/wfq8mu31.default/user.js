// arkenfox stuff - https://github.com/arkenfox/user.js/blob/master/user.js

/* 0000: disable about:config warning ***/
user_pref("browser.aboutConfig.showWarning", false);

/*** [SECTION 0100]: STARTUP ***/
/* 0102: set startup page [SETUP-CHROME]
 * 0=blank, 1=home, 2=last visited page, 3=resume previous session
 * [NOTE] Session Restore is cleared if history is also cleared (2811+), and not used in Private Browsing mode
 * [SETTING] General>Startup>Restore previous session ***/
user_pref("browser.startup.page", 0);
/* 0104: set NEWTAB page
 * true=Firefox Home (default, see 0105), false=blank page
 * [SETTING] Home>New Windows and Tabs>New tabs ***/
user_pref("browser.newtabpage.enabled", false);
/* 0105: disable sponsored content on Firefox Home (Activity Stream)
 * [SETTING] Home>Firefox Home Content ***/
user_pref("browser.newtabpage.activity-stream.showSponsored", false); // [FF58+] Sponsored stories
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false); // [FF83+] Sponsored shortcuts
user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false); // [FF140+] Support Firefox
/* 0106: clear default topsites
 * [NOTE] This does not block you from adding your own ***/
user_pref("browser.newtabpage.activity-stream.default.sites", "");

/** ACTIVITY STREAM ***/
/* 0335: disable Firefox Home (Activity Stream) telemetry ***/
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);

/** STUDIES ***/
/* 0340: disable Studies
 * [SETTING] Privacy & Security>Firefox Data Collection and Use>Install and run studies ***/
user_pref("app.shield.optoutstudies.enabled", false);
/* 0341: disable Normandy/Shield [FF60+]
 * Shield is a telemetry system that can push and test "recipes"
 * [1] https://mozilla.github.io/normandy/ ***/
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

/////////////////////////////////////////////
// other


// Dark theme
user_pref("browser.devedition.theme.enabled", true);
user_pref("devtools.theme", "dark");

// Removes the “Translate Selection” button from the right-click menu.
user_pref("browser.translations.select.enable", false);

// Disables the built-in Firefox screenshot functionality, which also removes the “Take Screenshot” button.
//user_pref("screenshots.browser.component.enabled", false);

// Disables Text Fragments support, which also removes the “Copy Link to Highlight” button (and disables the auto-focus on URLs that include #:~:text=...).
user_pref("dom.text_fragments.enabled", false);

// Removes the “Copy Clean Link” / “Copy Link Without Site Tracking” buttons.
user_pref("privacy.query_stripping.strip_on_share.enabled", false);

// Disables the DevTools Accessibility Inspector and removes the “Inspect Accessibility Properties” button.
user_pref("devtools.accessibility.enabled", false);

// Removes the “Ask an AI Chatbot” button.
user_pref("browser.ml.chat.menu", false);

// Disables Link Previews (and the AI-generated key points inside them), removing “Preview Link” button.
user_pref("browser.ml.linkPreview.enabled", false);

// Disables OCR on images, removing the “Copy Text From Image” button.
user_pref("dom.text-recognition.enabled", false);

// Disables Visual Search (Google Lens integration) and removes “Search Image with Google Lens” button.
user_pref("browser.search.visualSearch.featureGate", false);

// Turns off native macOS context menus so Firefox uses its own menus. This removes the “Services” button.
user_pref("widget.macos.native-context-menus", false);

// Completely disables Firefox’ printing UI and capabilities, which also removes the “Print” and “Print Selection…” buttons.
user_pref("print.enabled", false);

