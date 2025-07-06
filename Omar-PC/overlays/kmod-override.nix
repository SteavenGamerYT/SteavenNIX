final: prev: {
  kmod-blacklist-ubuntu = prev.kmod-blacklist-ubuntu.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      ./Dont-blacklist-pcspkr.patch
    ];
  });

  # Optional: make it the default kmod for the system
  # kmod = final.kmod-blacklist-ubuntu;
}
