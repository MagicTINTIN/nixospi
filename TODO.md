# TODO
- [x] set ip addr
- [x] setup basic apache webserver
- [x] use cloudflare to solve ipv6 only
- [ ] only open some ports and add firewall (ufw limit 22/tcp to prevent brute force)
- [x] change username
- [ ] default login
- [ ] ipv6 to ipv4 proxy ?

- [ ] activate ssh : 
    - [ ] prevent root login
    - [ ] change ssh port
    - [ ] use ssh key
    - [ ] 2FA ? Authy ?

- [ ] setup a watcher/dashboard : 
    - [ ] accessible from web with password
    - [ ] discord bot that sends basic logs

- [ ] access via vpn
- [ ] auth/cas
- [ ] config apache multi domains
- [ ] add redundancy
- [ ] sync servers
- [ ] sync db

# Ideas
- [ ] detect forcebrute with utils like fail2ban
- [ ] watch logs (/var/log/[syslog|message|mail.log|apache2</error.log>|mysql</error.log>])
- [ ] autofetch and pull for updates ?
# Later
- [ ] send important logs by sms using gsm
