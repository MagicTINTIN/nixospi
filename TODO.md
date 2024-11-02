# TODO
- [x] set ip addr
- [x] setup basic apache webserver
- [x] use cloudflare to solve ipv6 only
- [x] set up origin CA SSL certificates
- [x] only open some ports and add firewall (ufw limit 22/tcp to prevent brute force)
- [x] change username
- [x] default login
- [x] system watchdog
- [x] ipv6 to ipv4 proxy ?

- [x] activate ssh : 
    - [x] prevent root login
    - [ ] change ssh port
    - [x] use ssh key
    - [ ] 2FA ? Authy ?

- [ ] setup a watcher/dashboard : 
    - [ ] accessible from web with password
    - [ ] discord bot that sends basic logs

- [x] access via vpn
- [ ] auth/cas
- [w] config apache multi domains
- [ ] add redundancy
- [ ] sync servers
- [ ] sync db

# Ideas
- [x] detect forcebrute with utils like fail2ban
- [ ] watch logs (/var/log/[syslog|message|mail.log|apache2</error.log>|mysql</error.log>])
- [ ] autofetch and pull for updates ?
# Later
- [ ] send important logs by sms using gsm
