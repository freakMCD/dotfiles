{config, ...}:
{
 home.file."nix/home/config/qutebrowser/css/gruvbox.css".text = /* css */ ''
      :root {
        --bg0: #${config.colors.bg0};
        --bg1: #${config.colors.bg1};
        --bg2: #${config.colors.bg2};
        --bg3: #${config.colors.bg3};
        --bg4: #${config.colors.bg4};

        --gray: #${config.colors.gray};
        --muted-white: #${config.colors.white};

        --red: #${config.colors.red};
        --green: #${config.colors.green};
        --yellow: #${config.colors.yellow};
        --blue: #${config.colors.blue};
        --magenta: #${config.colors.magenta};
        --cyan: #${config.colors.cyan};
        --orange: #${config.colors.orange};
        --white: #${config.colors.white};

        --bright-red: #${config.colors.b_red};
        --bright-green: #${config.colors.b_green};
        --bright-yellow: #${config.colors.b_yellow};
        --bright-blue: #${config.colors.b_blue};
        --bright-magenta: #${config.colors.b_magenta};
        --bright-cyan: #${config.colors.b_cyan};
        --bright-orange: #${config.colors.b_orange};
        --bright-white: #${config.colors.b_white};
      }

      * { font-family: LiterationSans Nerd Font !important; }
      /* --- Global Elements --- */
      html, body, table, 
      #content, #mw-content-text,
      .repository-content, .container-lg,
      .commentarea .userfg, .comments-page .panestack-title {
        background: var(--bg0) !important;
        color: var(--white) !important;
      }
      
      p {
        color: var(--white) !important;
      }
      
      /* --- Links --- */
      a {
        color: var(--bright-cyan) !important;
        text-decoration: none;
      }
      
      a:visited {
        color: var(--bright-magenta) !important;
      }
      
      a:hover {
        color: var(--bright-yellow) !important;
        text-decoration: underline;
      }
      
      /* --- Code Blocks --- */
      code, pre {
        background-color: var(--bg2) !important;
        color: var(--bright-cyan) !important;
      }
      pre code {
        background: none !important;
        color: inherit;
      }
      
      /* --- Tables --- */
      table {
        color: var(--bright-white) !important;
        border-collapse: collapse !important;
      }
      th {
        border-bottom: 1px solid var(--bg4) !important;
        background-color: var(--bg3) !important;
      }
      td{
        border-bottom: 1px solid var(--bg4) !important;
        background-color: var(--bg1) !important;
      }
      
      
      /* --- Images --- */
      img {
        filter: opacity(0.85);
      }
      
      /* --- Headings --- */
      h1 { color: var(--bright-yellow) !important; }
      h2 { color: var(--bright-orange) !important; }
      h3 { color: var(--bright-red) !important; }
      h4 { color: var(--bright-blue) !important; }
      h5 { color: var(--bright-magenta) !important; }
      h6 { color: var(--bright-cyan) !important; }
      
      /* --- Buttons --- */
      button {
      
        transition: background 0.2s ease, color 0.2s ease;
      }
      
      button:hover {
        background-color: var(--bg2) !important;
        color: var(--bright-yellow) !important;
      }
      
      /* ================================================= */
      /*                Per Site Styles                    */
      /* ================================================= */
      
      /* ===== YouTube ===== */
      
      ytd-app, {
        background: var(--bg0) !important;
      }
      ytd-guide-entry-renderer[active] {
        background-color: var(--bright-orange) !important;
        color: var(--white) !important; /* Ensure text is readable */
      }
      ytd-guide-entry-renderer:not([active]):hover {
        background-color: var(--bg2) !important;
        transition: background-color 0.2s ease;
      }

      /* ===== Reddit ===== */
      
      .title {
        color: var(--white) !important;
        font-weight: bold;
      }
      .comment {
        background-color: var(--bg1) !important;
        padding: 8px 10px 0px 8px;
        margin: 8px 0;
        border-radius: 20px;
      }
      .tagline {
        color: var(--bright-white) !important;
      }
      
      /* ===== Github ===== */
      
      td.focusable-grid-cell {
        border-bottom: none !important;
        background-color: var(--bg1) !important;
      }
  '';
}
