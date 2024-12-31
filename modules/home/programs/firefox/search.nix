{pkgs}: {
  force = true;
  default = "Kagi";
  order = ["DuckDuckGo" "Kagi" "Youtube" "NixOS Options" "Nix Packages" "GitHub" "HackerNews"];

  engines = {
    "Bing".metaData.hidden = true;
    "Amazon.com".metaData.hidden = true;
    "Google".metaData.hidden = true;

    "Kagi" = {
      iconUpdateURL = "https://kagi.com/favicon.ico";
      updateInterval = 24 * 60 * 60 * 1000;
      definedAliases = ["@k"];
      urls = [
        {
          template = "https://kagi.com/search";
          params = [
            {
              name = "q";
              value = "{searchTerms}";
            }
          ];
        }
      ];
    };

    "YouTube" = {
      iconUpdateURL = "https://youtube.com/favicon.ico";
      updateInterval = 24 * 60 * 60 * 1000;
      definedAliases = ["@yt"];
      urls = [
        {
          template = "https://www.youtube.com/results";
          params = [
            {
              name = "search_query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
    };

    "Nix Packages" = {
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = ["@np"];
      urls = [
        {
          template = "https://search.nixos.org/packages";
          params = [
            {
              name = "type";
              value = "packages";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
    };

    "NixOS Options" = {
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = ["@no"];
      urls = [
        {
          template = "https://search.nixos.org/options";
          params = [
            {
              name = "channel";
              value = "unstable";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
    };

    "GitHub" = {
      iconUpdateURL = "https://github.com/favicon.ico";
      updateInterval = 24 * 60 * 60 * 1000;
      definedAliases = ["@gh"];

      urls = [
        {
          template = "https://github.com/search";
          params = [
            {
              name = "q";
              value = "{searchTerms}";
            }
          ];
        }
      ];
    };

    "Home Manager" = {
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = ["@hm"];

      url = [
        {
          template = "https://mipmip.github.io/home-manager-option-search/";
          params = [
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
    };

    "HackerNews" = {
      iconUpdateURL = "https://hn.algolia.com/favicon.ico";
      updateInterval = 24 * 60 * 60 * 1000;
      definedAliases = ["@hn"];

      url = [
        {
          template = "https://hn.algolia.com/";
          params = [
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
    };
  };
}
