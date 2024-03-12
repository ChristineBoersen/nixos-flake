mkdir -p /home/nixos/.vscode-server
sudo cp ./server-env-setup /home/nixos/.vscode-server/server-env-setup
sudo chmod +x /home/nixos/.vscode-server/server-env-setup

#1. Install NixOS as a WSL 2 distro. Currently there's a community supported repository here ([NixOS-WSL](https://github.com/nix-community/NixOS-WSL)).
#2. Install Visual Studio Code and its [Remote-WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) extension.
#3. Make sure your NixOS system have `wget` installed. If you have no idea on this, run `nix profile install nixpkgs#wget` command to install `wget`.
#4. Run `cp ./server-env-setup ~/.vscode-server/server-env-setup`. See [here](https://code.visualstudio.com/docs/remote/wsl#_advanced-environment-setup-script) for description.
#5. Now VSCode can connect to your NixOS!
