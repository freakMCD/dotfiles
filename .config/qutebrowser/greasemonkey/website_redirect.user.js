// ==UserScript==
// @name        Website Redirect
// @match       *://*.facebook.com/*
// @match       *://*.youtube.com/*
// @grant       none
// @run-at      document-start
// ==/UserScript==

const redirects = {
  'www.facebook.com': {
    '^/$': '/facultaddecienciasfisicasymatematicas',
    // Add more mappings for Facebook if needed
  },
  'www.youtube.com': {
    '^/$': '/feed/playlists',
    // Add more mappings for YouTube if needed
  },
  // Add more mappings for other websites as needed
};

const currentHostname = location.hostname;
const currentPathname = location.pathname;

if (redirects.hasOwnProperty(currentHostname)) {
  const pathnameMappings = redirects[currentHostname];
  for (const pathRegex in pathnameMappings) {
    if (new RegExp(pathRegex).test(currentPathname)) {
      location.pathname = pathnameMappings[pathRegex];
      break;
    }
  }
}
