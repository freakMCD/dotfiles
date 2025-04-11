# Content
c.content.autoplay = False
c.content.dns_prefetch = False
c.content.notifications.enabled = False
c.content.geolocation = False
c.content.blocking.enabled = True
c.content.blocking.method = "hosts"
c.content.fullscreen.window = True
c.content.geolocation = False
c.content.webgl = False

# Disable protocol handler for specified websites
config.set('content.register_protocol_handler', False, 'mail.google.com')

# Javascript
c.content.javascript.enabled = True
c.content.javascript.clipboard = "access-paste"
c.content.javascript.log_message.excludes = {"userscript:_qute_stylesheet": ["*Refused to apply inline style because it violates the following Content Security Policy directive: *"], 
                                             "userscript:_qute_js": ["*TrustedHTML*"]}

c.content.javascript.log_message.excludes = {"userscript:_qute_stylesheet": ["*Refused to apply inline style because it violates the following Content Security Policy directive: *"], 
                                             "userscript:_qute_js": ["*TrustedHTML*"]}

