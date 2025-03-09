// ==UserScript==
// @name               Auto Skip YouTube Ads
// @namespace          https://github.com/tientq64/userscripts
// @version            7.1.1
// @description        Automatically skip YouTube ads instantly. Undetected by YouTube ad blocker warnings.
// @match              https://*.youtube.com/watch?v=*
// @grant              none
// @license            MIT
// @compatible         firefox
// @compatible         chrome
// @compatible         opera
// @compatible         safari
// @compatible         edge
// @noframes
// ==/UserScript==

(function() {
    'use strict';

    const config = {
        checkInterval: 500,
        mutationObserver: true,
        hideElements: true,
        skipAds: true,
        debug: false
    };

    function log(...args) {
        if (config.debug) console.log('[YT Ad Skipper]', ...args);
    }

    // Improved ad detection
    function detectAds() {
        return {
            adShowing: document.querySelector('.ad-showing, .ad-interrupting'),
            videoAdContainer: document.querySelector('.video-ads'),
            skipButton: document.querySelector('.ytp-ad-skip-button-modern, .ytp-ad-skip-button'),
            overlayAd: document.querySelector('.ytp-ad-overlay-container'),
            surveyAd: document.querySelector('.ytp-ad-survey'),
            previewAd: document.querySelector('.ytp-preview-ad'),
            pieCountdown: document.querySelector('.ytp-ad-timed-pie-countdown'),
            playerBar: document.querySelector('.ytp-ad-player-overlay'),
            audioAds: document.querySelector('.ytp-audio-ad-preview-container')
        };
    }

    function handleAds() {
        const ads = detectAds();
        const video = document.querySelector('video');
        
        // Skip button click
        if (ads.skipButton) {
            ads.skipButton.click();
            log('Clicked skip button');
            return true;
        }

        // Handle survey ads
        if (ads.surveyAd) {
            const closeButton = document.querySelector('.ytp-ad-survey-close-button');
            if (closeButton) {
                closeButton.click();
                log('Closed survey ad');
                return true;
            }
        }

        // Detect ads in video ads container
        if (ads.videoAdContainer) {
            const adCount = ads.videoAdContainer.querySelectorAll('*').length;
            if (adCount > 0 && video && !video.paused) {
                try {
                    video.currentTime = video.duration;
                    if (video.playbackRate < 16) video.playbackRate = 16;
                    video.muted = true;
                    log('Fast-forwarding ad');
                    return true;
                } catch (e) {
                    log('Error fast-forwarding:', e);
                }
            }
        }

        // Handle overlay ads
        if (ads.overlayAd) {
            ads.overlayAd.remove();
            log('Removed overlay ad');
            return true;
        }

        // Handle audio ads
        if (ads.audioAds) {
            const skipButton = document.querySelector('.ytp-audio-ad-preview-skip-button');
            if (skipButton) {
                skipButton.click();
                log('Skipped audio ad');
                return true;
            }
        }

        return false;
    }

    function hideAdElements() {
        const elements = [
            '.ytp-ad-module',
            '.ytp-ad-image-overlay',
            '.companion-ad',
            '.ytd-promoted-sparkles-web-renderer',
            '#player-ads',
            '.ytp-ad-message-container',
            '.ytp-ad-action-interstitial-background-container',
            'ytd-ad-slot-renderer',
            'ytd-promoted-sparkles-text-search-renderer',
            'yt-mealbar-promo-renderer',
            'ytd-banner-promo-renderer',
            '#masthead-ad',
            '.ytp-preview-ad'
        ];

        elements.forEach(selector => {
            document.querySelectorAll(selector).forEach(el => {
                el.style.display = 'none';
            });
        });
    }

    function initMutationObserver() {
        const observer = new MutationObserver(mutations => {
            mutations.forEach(() => {
                handleAds();
                hideAdElements();
            });
        });

        observer.observe(document.body, {
            subtree: true,
            childList: true,
            attributes: false,
            characterData: false
        });

        return observer;
    }

    function main() {
        if (config.hideElements) {
            hideAdElements();
            setInterval(hideAdElements, 3000);
        }

        if (config.mutationObserver) {
            initMutationObserver();
        }

        if (config.skipAds) {
            setInterval(handleAds, config.checkInterval);
        }

        log('Initialized');
    }

    // Wait for player to load
    if (document.body) {
        main();
    } else {
        window.addEventListener('DOMContentLoaded', main);
    }
})();
