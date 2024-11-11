// ==UserScript==
// @name         Remove Watch Later and Liked Videos Items
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Remove "Watch later" and "Liked videos" items from YouTube completely
// @author       You
// @match        https://www.youtube.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // Function to remove unwanted elements
    function removeElements() {
        // Select all the rich item renderers with the specific class
        const items = document.querySelectorAll('ytd-rich-item-renderer.style-scope.ytd-rich-grid-renderer');

        items.forEach(item => {
            // Check if the item contains a child with title "Watch later" or "Liked videos"
            const titleElement = item.querySelector('[title="Watch later"], [title="Liked videos"]');
            if (titleElement) {
                item.remove(); // Completely remove the item from the DOM
            }
        });
    }

    // Run the function to remove elements
    removeElements();

    // Optional: Observe for dynamically loaded content (in case of infinite scroll or AJAX)
    const observer = new MutationObserver(removeElements);
    observer.observe(document.body, { childList: true, subtree: true });
})();
