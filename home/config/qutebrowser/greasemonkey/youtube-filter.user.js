// ==UserScript==
// @name         Optimized YouTube Shorts Remover
// @namespace    http://tampermonkey.net/
// @version      1.3
// @description  Efficiently removes Shorts from Subscriptions
// @match        *://www.youtube.com/*
// @grant        GM_addStyle
// @license      MIT
// ==/UserScript==

GM_addStyle(`
    #related,
    #player,
    #secondary,
    #comments,
    .miniplayer,
    ytd-merch-shelf-renderer,
    ytd-reel-shelf-renderer,
    #content .ytd-rich-shelf-renderer,
    ytd-guide-section-renderer:nth-child(1) #items > ytd-guide-entry-renderer:nth-child(2),
    ytd-guide-section-renderer:nth-child(3),
    ytd-guide-section-renderer:nth-child(4),
    #footer
    {
        display: none !important;
    }
    
    ytd-thumbnail a.ytd-thumbnail,
    ytd-thumbnail::before {
        border-radius: 0 !important;
    }
`);

