More help at
https://github.com/Misterio77/nix-starter-configs/tree/main
or in [help file](help.md)

# Install

Create a file hostname.conf containing your hostname in the /etc/nixos folder.
Yup it is an impure nixos, and I don't care... this piece of shit doesn't enable us to have a basic try catch/default value if file doesn't not exist...

# Main commands

```sh
nix flake update
```

```sh
# to be used
sudo nixos-rebuild switch --flake .#$(cat /etc/nixos/hostname.conf) --impure
# generic
sudo nixos-rebuild switch --flake .#$(cat ./nixos/hostname 2>/dev/null || echo nixamer)
# what it does
sudo nixos-rebuild switch --flake .#nixamer
```

```sh
home-manager switch --flake .#user@$(cat /etc/nixos/hostname.conf) --impure
home-manager switch --flake .#user@$(cat ./nixos/hostname 2>/dev/null || echo nixamer)
home-manager switch --flake .#user@nixamer
```

# Maintenance

```zsh
# zsh only
nixcf-debug-print
nixhm-debug-print
```