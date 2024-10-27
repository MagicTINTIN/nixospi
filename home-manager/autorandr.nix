{ config, pkgs, home, lib, ... }:
{
  my-autorandr = {
    # laptop display
    display1 = {
      name = "eDP-1";
      fp = "00ffffffffffff0009e59f060000000001190104951a0e7802352099595d9829205054000000010101010101010101010101010101013e1c56a0500016303020360000901000001ad41256a0500016303020360000901000001a00000000000000000000000000000000000000000002000c43f90b3c6e1e16286f0000000042";
    };
    # samsung via VGA
    display2 = {
      name = "DP-3";
      fp = "00ffffffffffff004c2d23053232524c34130104a5301b78223581a656489a241250542308008100814081809500a940b30001010101023a801871382d40582c4500dd0c1100001e000000fd00383c1e5111000a202020202020000000fc0053796e634d61737465720a2020000000ff00484c4a534330333431300a202000f2";
    };
  };
  # home.packages = with pkgs; [
  #   (writeShellScriptBin "hi" ''
      
  #   '')
  # ];
  home.activation = {
    # Define a custom activation step named `myScriptActivation` # ${pkgs.bash}/bin/bash ${./work-postswitch.sh}
    reloadingAutorandr = lib.hm.dag.entryAfter ["writeBoundary"] '' 
      # Run your script here
      
      echo "Reloading autorandr (exec autorandr -c)"
      ${pkgs.autorandr}/bin/autorandr --change
    '';
  };
}
