// ==UserScript==
// @name            Remove Background Image
// @include         *hbpms.blogspot.com/*
// @include         *.protondb.com/*
// @include         *ebinaria.com/*
// @run-at          document-start
// ==/UserScript==

(function IIFE() {
    'use strict';
 
    document.addEventListener('readystatechange', function onReadyStateChange() {
        if (document.readyState == 'interactive') {
            const style = document.createElement('style');
            document.head.appendChild(style);
            style.innerHTML = `
 
.root, .main {
    background: none !important;
}

.root, .elementor-background-overlay {
    background-image: none !important;
} 
            `;
        }
    });
})();
 
