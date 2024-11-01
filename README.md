More help at
https://github.com/Misterio77/nix-starter-configs/tree/main
or in [help file](help.md)

# Install

Create a file hostname.conf containing your hostname in the /etc/nixos folder.
Yup it is an impure nixos, and I don't care... this piece of shit doesn't enable us to have a basic try catch/default value if file doesn't not exist...

> [!WARNING]
> Think to creaate `hostname.conf` `username.conf` and `sshusername.conf`!

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
home-manager switch --flake .#$(cat /etc/nixos/username.conf)@$(cat /etc/nixos/hostname.conf) --impure
home-manager switch --flake .#user@$(cat /etc/nixos/hostname.conf) --impure
home-manager switch --flake .#user@$(cat ./nixos/hostname 2>/dev/null || echo nixamer)
home-manager switch --flake .#user@nixamer
```

## SSH User
```sh
# not sure
sudo chown -R $(cat /etc/nixos/username.conf):www .                
sudo chmod -R g+r . 
# git doesnt work
git config --add safe.directory /etc/nixos
git config safe.directory

# so you maight
mv .git .notgittemp
sudo -u $(cat /etc/nixos/sshusername.conf) home-manager switch --flake .#$(cat /etc/nixos/sshusername.conf)@$(cat /etc/nixos/hostname.conf) --impure
mv .notgittemp .git
```

## Setup Tunnel VPN (ipv6........)
```sh
cloudflared login
cloudflared tunnel create vpn_tunnel
```

# Maintenance

```zsh
# zsh only
nixcf-debug-print
nixhm-debug-print
```