// ==UserScript==
// @name         Optimized YouTube Shorts Remover
// @namespace    http://tampermonkey.net/
// @version      1.3
// @description  Efficiently removes Shorts from Subscriptions
// @match        *://web.whatsapp.com/*
// @grant        GM_addStyle
// @license      MIT
// ==/UserScript==
//
GM_addStyle(`
  [aria-label='Estado'],
  [aria-label='Canales']{
    display: none !important;
  }
`);

