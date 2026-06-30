{ lib, buildNpmPackage, fetchurl, nodejs }:

let
  version = "0.5.15";

  router9 = buildNpmPackage rec {
    pname = "9router";
    inherit version;

    src = fetchurl {
      url = "https://registry.npmjs.org/9router/-/9router-${version}.tgz";
      hash = "sha256-54vXNHbCrXqW3Wu0zwvVmjyvvDE7coCFCtMnAM/DNcM="; 
    };

    npmDepsHash = "sha256-UajrXGnVuIl/Gl9eQtdBkbyRZRgxkx9mGGM0xUVE8P8="; 
    
    inherit nodejs;
    makeCacheWritable = true;

    postPatch = ''
      if [ -f "${./packages/9router/package-lock.json}" ]; then
        echo "Using vendored package-lock.json"
        cp "${./packages/9router/package-lock.json}" ./package-lock.json
      else
        echo "No vendored package-lock.json found, creating a minimal one"
        exit 1
      fi
    '';

    dontNpmBuild = true;
    dontNpmInstall = true;


    installPhase = ''
      mkdir -p $out/lib/node_modules/9router
      cp -a . $out/lib/node_modules/9router/
      
      mkdir -p $out/bin
      ln -s $out/lib/node_modules/9router/cli.js $out/bin/9router
      chmod +x $out/bin/9router
    '';

    meta = with lib; {
      description = "9Router CLI tool";
      homepage = "https://github.com/decolua/9router";
      mainProgram = "9router";
    };
  };
in
router9
