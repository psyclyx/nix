{ lib, ... }:
let
  inherit (lib)
    genList
    range
    map
    listToAttrs
    ;

  mkPorts =
    {
      prefix,
      start ? 1,
      count ? 1,
      base ? { },
    }:
    listToAttrs (
      map (index: {
        name = "${prefix}${idx}";
        value = base;
      }) (range start (start + count))
    );

  centropower = {
    ct-pdu10-sp = {
      pdu = {
        surgeProtection = true;
        switched = true;
      };
      ports = {
        "INPUT".port.socket = "C13";
      }
      // (mkPorts {
        prefix = "CH";
        count = 10;
        base.socket = "NEMA 5-15R";
      });
    };
  };

  riveco = {
    # no model name? this thing is jank, need to replace
    power-distribution-unit = {
      pdu.surgeProtection = true;
      ports = {
        "AC-IN".port.socket = "NEMA 5-15P";
      }
      // (mkPorts {
        prefix = "OUT";
        count = 6;
        socket = "NEMA 5-15R";
      })
      // (mkPorts {
        prefix = "USB";
        count = 2;
        socket = "USB 2.0 Type A Female";
      });
    };
  };

  microtik = {
    "css326-24g-2s+-rm" = {
      switch = {
        managed = true;
        layer = 2;
        vlanSupport = true;
        rackMount = true;
        powerOverEthernet = false;
      };

      ports =
        (mkPorts {
          prefix = "ether";
          count = 24;
          base = {
            type = "RJ45";
            speed = "1G";
          };
        })
        // (mkPorts {
          prefix = "sfpplus";
          count = 2;
          base = {
            type = "SFP+";
            speed = "10G";
          };
        });
    };
  };
in
{
  devices = {
    pdu-1 = centropower.ct-pdu10-sp;
    pdu-2 = riveco.power-distribution-unit;

    mt-sw-1 = microtik."css326-24g-2s+-rm";
  };
}
