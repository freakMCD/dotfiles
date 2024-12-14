// ==UserScript==
// @name    Userstyle (youtube.css)
// @include    *youtube.com*
// ==/UserScript==
(function() {
    'use strict';

    // Function to remove "Watch later" and "Liked videos" items
    function removeElements() {
        const items = document.querySelectorAll('ytd-rich-item-renderer.style-scope.ytd-rich-grid-renderer');
        items.forEach(item => {
            const titleElement = item.querySelector('[title="Watch later"], [title="Liked videos"]');
            if (titleElement) {
                item.remove();
            }
        });
    }

    // Run the function to remove elements
    removeElements();

    // Observe for dynamically loaded content
    const observer = new MutationObserver(removeElements);
    observer.observe(document.body, { childList: true, subtree: true });

    // Add custom CSS to hide comments
    GM_addStyle(`
        ytd-comments { 
            display: none !important; 
        }
    `);
})();
