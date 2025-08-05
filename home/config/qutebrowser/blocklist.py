# Content
c.content.autoplay = False
c.content.dns_prefetch = False
c.content.notifications.enabled = "ask"
c.content.geolocation = False
c.content.blocking.enabled = True
c.content.blocking.method = "hosts"
c.content.fullscreen.window = True
c.content.geolocation = False
c.content.webgl = False

# Disable protocol handler for specified websites
config.set('content.register_protocol_handler', False, 'mail.google.com')


