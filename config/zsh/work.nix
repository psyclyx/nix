{lib, ...}: {
  programs.zsh = {
    shellAliases = {
      watch = "shadow-cljs watch";
      lr = "lein refresh";
      lrr = "lein refresh repl";
    };
    initExtra = lib.mkAfter ''
      path_append "''${HOME}/projects/app/bin"
      export NODE_OPTIONS=--openssl-legacy-provider
      export VAULT_ADDR="https://vault.amperity.top:8200"

      web-ui () {
        # ShadowCLJS must be run from the `web-ui` directory
        cd `git rev-parse --show-toplevel`/service/web/web-ui

        # The browser can only connect to ShadowCLJS through our proxy container
        docker-compose up -d web-proxy &

        # Finally, start ShadowCLJS
        shadow-cljs watch app revl
      }

      # Default AWS profile to use from ~/.aws/config
      export AWS_PROFILE=dev

      aws-profile () {
        export AWS_PROFILE="$1"
        aws sso login
        aws configure list
      }

      aws-sts () {
        aws sts get-caller-identity > /dev/null
        if [ $? -ne 0 ]; then
          aws sso login
        fi
        eval "$(aws2-wrap --export)"
        aws configure list
      }
    '';
  };
}
