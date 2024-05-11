// ==UserScript==
// @match *://*.steampowered.com/*
// @match *://*.google.com/maps/*
// @match *://bancaporinternet.interbank.pe/*
// @match *://web.whatsapp.com/*
// @match *://artofproblemsolving.com/*
// ==/UserScript==

const meta = document.createElement('meta');
meta.name = "color-scheme";
meta.content = "dark light";
document.head.appendChild(meta);
