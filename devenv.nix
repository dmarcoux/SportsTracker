{ pkgs, lib, config, inputs, ... }:

let
  # Anything which is referenced multiple times is defined as a variable here...

  # Locales
  glibcLocales = pkgs.glibcLocales;

  # Bundle of SSL certificates
  cacert = pkgs.cacert;
in
{
  # Set environment variables
  env = {
    # Set LANG for locales
    LANG = "C.UTF-8";

    # Remove duplicate commands from Bash shell command history
    HISTCONTROL = "ignoreboth:erasedups";

    # Without this, there are warnings about LANG, LC_ALL and locales.
    # Many tests fail due those warnings showing up in test outputs too...
    # This solution is from: https://gist.github.com/aabs/fba5cd1a8038fb84a46909250d34a5c1
    LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";

    # For the bundle of SSL certificates to be used in applications (like curl and others...)
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  # Install packages - https://devenv.sh/packages/
  packages = with pkgs; [
    # Timezones
    tzdata
    # Locales
    glibcLocales
    # Bundle of SSL certificates
    cacert
  ];

  # Setup languages and their tools - https://devenv.sh/languages/
  languages.python = {
    enable = true;
    version = "3.12.7";
    # Enable Python virtual environment
    venv = {
      enable = true;
      requirements = ./requirements.txt;
    };
  };

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  # scripts.hello.exec = ''
  #   echo hello from $GREET
  # '';

  enterShell = ''
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
  '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
