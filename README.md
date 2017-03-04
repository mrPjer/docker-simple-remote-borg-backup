Simple encrypted remote daily backups using borgbackup
-------------------------------------------------------------------------
(WIP)

This is a simple container that can be used to set up scheduled, hassle-free, encrypted backups to an insecure remote host.

The backups will run daily at 2AM and will (by default) store the last 7 daily snapshots, the last 4 weekly ones and the last 6 monthly ones.

Prerequisites
==========
CLIENT is the host you will be running the container on. SERVER is the host that will store the remote backup.

1. The SERVER needs to have an SSH daemon running with pubkey authentication enabled.
2. The SERVER needs to have borg installed.

Set-up
=====
On the SERVER, create a new user that will host the backups:
`adduser *username*`

Generate an SSH keypair with `ssh-keygen`.
Deploy the public key to username@SERVER:.ssh/authorized_users

Store the public and private key in a folder named ssh.
Create a file ssh/known_hosts and store the SERVER's hostname and fingerprint inside.
Copy the folder ssh to the CLIENT.

Run the container
==============
```
docker run --rm -it \
    -e REPOSITORY=user@SERVER:backup-name \
    -e PASSPHRASE=encryption_passphrase \
    -v *path_to_ssh*:/root/.ssh:ro \
    -v *folder_to_back_up*:/data:ro \
    psegina/simple-remote-borg-backup
```

In docker-compose
===============
```
backup:
    image: psegina/simple-remote-borg-backup
    environment:
        - REPOSITORY=user@SERVER:backup-name
        - PASSPHRASE=supersecretpassphrase
    volumes:
        - ./ssh:/root/.ssh:ro
        - ./data:/data:ro
    restart: always
```
