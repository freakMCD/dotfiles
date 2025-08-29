
# Disable protocol handler for specified websites
config.set('content.register_protocol_handler', False, 'mail.google.com')

# Javascript disabled for selected websites
for site in [
    'wikipedia.org',
    'genius.com',
    '*.fandom.com',
    'math.stackexchange.com',
]:
    config.set('content.javascript.enabled', False, site)


