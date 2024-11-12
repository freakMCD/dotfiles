// ==UserScript==
// @name            Mangareader
// @match         https://mangareader.to/read/*
// @run-at          document-start
// ==/UserScript==
(function IIFE() {
    'use strict';
 
    document.addEventListener('readystatechange', function onReadyStateChange() {
        if (document.readyState == 'interactive') {
            const style = document.createElement('style');
            document.head.appendChild(style);
            style.innerHTML = `
* {
    visibility: hidden;
}
.image-horizontal {
    visibility: visible;
    position: fixed !important;
}
            `;
        }
    });
})();
 
