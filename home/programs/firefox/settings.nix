let
  behavior = {
    "app.update.auto" = false;

    "browser.aboutconfig.showWarning" = false;
    "browser.ctrlTab.recentlyUsedOrder" = false;
    "browser.discovery.enabled" = false;

    "browser.download.useDownloadDir" = false;
    "browser.download.viewableInternally.typeWasRegistered.svg" = true;
    "browser.download.viewableInternally.typeWasRegistered.webp" = true;
    "browser.download.viewableInternally.typeWasRegistered.xml" = true;

    "browser.helperApps.deleteTempFileOnExit" = true;

    "browser.newtabpage.activity-stream.default.sites" = "";
    "browser.newtabpage.activity-stream.feeds.topsites" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.uitour.enabled" = false;

    "browser.shell.checkDefaultBrowser" = false;

    "browser.tabs.loadInBackground" = true;

    "distribution.searchplugins.defaultLocale" = "en-US";
    "general.useragent.locale" = "en-US";

    "widget.use-xdg-desktop-portal.file-picker" = 1;
  };

  extensions = {
    "extensions.pocket.enabled" = false;
    "extensions.update.enabled" = false;
    "extensions.autoDisableScopes" = 0;
    "extensions.webcompat.enable_picture_in_picture_overrides" = true;
    "extensions.webcompat.enable_shims" = true;
    "extensions.webcompat.perform_injections" = true;
    "extensions.webcompat.perform_ua_overrides" = true;
    "extensions.htmlaboutaddons.discover.enabled" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
  };

  perf = {
    "gfx.webrender.all" = true;
    "widget.dmabuf.force-enabled" = true;
  };

  print = {
    "print.print_footerleft" = "";
    "print.print_footerright" = "";
    "print.print_headerleft" = "";
    "print.print_headerright" = "";
  };

  privacy = {
    "browser.contentblocking.category" = "standard";
    "doh-rollout.balrog-migration-done" = true;
    "doh-rollout.doneFirstRun" = true;
    "privacy.donottrackheader.enabled" = true;
    "privacy.fingerprintingProtection" = true;
    "privacy.resistFingerprinting" = true;
    "privacy.resistFingerprinting.pbmode" = true;
    "privacy.query_stripping.enabled" = true;
    "privacy.query_stripping.enabled.pbmode" = true;
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.pbmode.enabled" = true;
    "privacy.trackingprotection.emailtracking.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;
    "privacy.trackingprotection.cryptomining.enabled" = true;
    "privacy.trackingprotection.fingerprinting.enabled" = true;
  };

  ui = {
    "browser.search.region" = "PL";
    "browser.search.widget.inNavBar" = true;

    "browser.urlbar.placeholderName" = "DuckDuckGo";
    "browser.urlbar.showSearchSuggestionsFirst" = false;

    "browser.urlbar.quickactions.enabled" = false;
    "browser.urlbar.quickactions.showPrefs" = false;
    "browser.urlbar.shortcuts.quickactions" = false;
    "browser.urlbar.suggest.quickactions" = false;

    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  };

  telemetry = {
    "app.normandy.api_url" = "";
    "app.normandy.enabled" = false;
    "app.shield.optoutstudies.enabled" = false;

    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "browser.ping-centre.telemetry" = false;
    "browser.vpn_promo.enabled" = false;

    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.healthreport.uploadEnabled" = false;

    "toolkit.coverage.endpoint.base" = "";
    "toolkit.coverage.opt-out" = true;
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.coverage.opt-out" = true;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.reportingpolicy.firstRun" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.shutdownPingSender.enabledFirstsession" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
  };
in
  behavior
  // extensions
  // print
  // perf
  // privacy
  // ui
  // telemetry
  // ui
