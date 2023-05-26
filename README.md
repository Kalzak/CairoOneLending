# Cairo1 Simple Lending Protocol

Exactly what the title says.

Not using Scarb or Protostar, we keep the project lean, just using a simple bash script.

## Environment setup

1. Install [Cairo](https://github.com/starkware-libs/cairo/releases/tag/v1.1.0-alpha0). Note that this link points to the version used for this project (`v1.1.0-alpha0`) rather than the latest.
1. Now your environment is ready.

## Compile

`./helper compile` to compile to `stdout`

`./helper compile-save`: to compile to `sierra/lending.json`

## Test

`./helper test`
