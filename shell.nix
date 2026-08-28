{ pkgs ? import <nixpkgs> { } }:

let
  withOpus = true;
in
pkgs.mkShell {
  name = "termusic-dev-shell";

  nativeBuildInputs = with pkgs; [
    pkg-config
    protobuf
    rustPlatform.bindgenHook

    # Rust toolchain / dev tooling
    cargo
    rustc
    rustfmt
    clippy
    cargo-nextest
  ];

  buildInputs = with pkgs;
    [
      dbus
      glib
      gst_all_1.gstreamer
      mpv-unwrapped
      openssl
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ]
    ++ lib.optionals withOpus [
      libopus
    ];

  RUSTFLAGS = "-C target-cpu=native";

  # So pkg-config / bindgen can find headers & libs at runtime in the shell
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

  shellHook = ''
    echo "termusic dev shell ready (withOpus=${if withOpus then "true" else "false"})"
  '';
}
