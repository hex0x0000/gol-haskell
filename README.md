[This repo has been migrated](https://git.bounceme.net/hex0x0000/gol-haskell)
# Conway's Game of Life in Haskell
Just a simple implementation of Conway's Game of Life written in Haskell

# Compiling
Install [stack](https://docs.haskellstack.org/en/stable/README/) (if you're using nix just type `nix-shell`)

Then:
```
$ stack build
$ stack exec gol-haskell-exe glider.json
```

# JSON
Alive cells, matrix size and time delay between generations can be specified with a JSON file that can be inputted to the program.

[Example](/glider.json)

