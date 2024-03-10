
# Nix Basics

 - NIX IS A FUNCTIONAL LANGUAGE
    - All results must be immutable
    - Expressions are evaluated lazily
    - Currying is fairly normal
    - Odd conventions such as defining the output and referencing it within the definition (yes it is as confusing as it sounds for a procedural programmer)
    - You may only define a value once, however you can set different properties in different files, and they will all converge to a single, non-overwritten value.
        You will receive an error if you try to set a value twice without showing intent (e.g. lib.mkForce someCoolValue )
    - The closest to mutating is merging two lists, with the // command but in collisions, the value on the right wins

# NixOS/Linux Basics
-

# Useful Methods
- fetchFromGitHub
-

