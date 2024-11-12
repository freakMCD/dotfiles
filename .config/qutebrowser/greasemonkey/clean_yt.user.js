// ==UserScript==
// @name         Focused YouTube
// @version      2024-09-05
// @author       Kervyn
// @namespace    https://raw.githubusercontent.com/KervynH/Focused-YouTube/main/main.user.js
// @description  Remove ads, shorts, and algorithmic suggestions on YouTube
// @match        *://*.youtube.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=youtube.com
// @run-at       document-end
// @grant        GM.addStyle
// ==/UserScript==

/* Credit:  https://github.com/lawrencehook/remove-youtube-suggestions */

'use strict';

// Config custom settings here
const SETTINGS = {
  /// homepage redirect ///
  hideHomepageButton: true,

  /// video player ///
  hideChat: true,
  hideRelatedVideos: true,
  hidePlayNextButton: true,
  hidePlayPreviousButton: true,
  hideMiniPlayerButton: true,

  /// shorts ///
  hideShorts: true,
};

// Mark settings in HTML
const HTML = document.documentElement;
Object.keys(SETTINGS).forEach(key => {
  HTML.setAttribute(key, SETTINGS[key]);
});

// Add css to remove unnecessary elements
const DESKTOP_BLOCK_LIST = [
  // Ads 
  '#masthead-ad',
  'ytd-mealbar-promo-renderer',
  'ytd-carousel-ad-renderer',
  '.ytd-display-ad-renderer',
  'ytd-ad-slot-renderer',
  'div.ytp-ad-overlay-image',
  '.iv-branding.annotation-type-custom.annotation',

  // Shorts
  'html[hideShorts="true"] ytd-rich-section-renderer',
  'html[hideShorts="true"] ytd-reel-shelf-renderer',

  // Left Bar Navigation 
  'a[href="/feed/subscriptions"]',
  'a[href="/feed/trending"]',
  'a[href="/feed/explore"]',
  'html[hideShorts="true"] a[title="Shorts"]',
  'html[hideShorts="true"] ytd-mini-guide-entry-renderer[aria-label="Shorts"]',
  'ytd-guide-section-renderer.ytd-guide-renderer.style-scope:nth-of-type(4)',
  'ytd-guide-section-renderer.ytd-guide-renderer.style-scope:nth-of-type(3)',
  'ytd-guide-section-renderer.ytd-guide-renderer.style-scope:nth-of-type(2)',

  // Homepage 
  'html[hideHomepageButton="true"] a:not(#logo)[href="/"]',

  // Video Player
  'html[hideRelatedVideos="true"] #secondary>div.circle',
  'html[hideRelatedVideos="true"] #related',
  'html[hideRelatedVideos="true"] .html5-endscreen',
  'html[hidePlayNextButton="true"] a.ytp-next-button.ytp-button',
  'html[hidePlayPreviousButton="true"] a.ytp-prev-button.ytp-button',
  'html[hideChat="true"] #chat',
  'html[hideMiniPlayerButton="true"] .ytp-button.ytp-miniplayer-button',
  // '#movie_player button.ytp-button.ytp-share-button',
  // '#movie_player button.ytp-button.ytp-watch-later-button',
  '.ytd-download-button-renderer.style-scope',

  // Search
  '#center',
  'div.sbdd_a',
  '#container.ytd-search ytd-search-pyv-renderer',
  '#container.ytd-search ytd-reel-shelf-renderer',
  '#container.ytd-search ytd-shelf-renderer',
];
if (location.hostname.startsWith('www.')) {
  DESKTOP_BLOCK_LIST.forEach(e => GM.addStyle(`${e} {display: none !important}`));
}
