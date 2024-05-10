// ==UserScript==
// @name        FB Redirect
// @match       https://www.facebook.com/*
// @grant       none
// @run-at      document-start
// ==/UserScript==

if (location.pathname === '/') {
  location.pathname = '/facultaddecienciasfisicasymatematicas';
}

