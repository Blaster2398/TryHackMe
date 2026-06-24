### Port scanning 

Used this command to list the ports 

```bash
nmap -Pn -sC -sV -p- -A 10.48.170.188
```

#### Got this as the output 


```bash 
Starting Nmap 7.99 ( https://nmap.org ) at 2026-06-24 11:28 +0530
Nmap scan report for 10.48.170.188
Host is up (0.066s latency).
Not shown: 65528 closed tcp ports (reset)
PORT      STATE SERVICE  VERSION
22/tcp    open  ssh      OpenSSH 8.2p1 Ubuntu 4ubuntu0.13 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 7a:ff:3f:d1:fc:69:16:6d:09:23:13:10:5b:56:9a:ff (RSA)
|   256 c1:5d:22:38:f9:7d:84:ae:c3:90:20:98:07:24:fa:25 (ECDSA)
|_  256 ec:3a:43:5b:da:ec:70:56:d1:a4:bd:98:8c:83:c6:b7 (ED25519)
111/tcp   open  rpcbind  2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100003  3           2049/udp   nfs
|   100003  3           2049/udp6  nfs
|   100003  3,4         2049/tcp   nfs
|   100003  3,4         2049/tcp6  nfs
|   100021  1,3,4      33513/tcp   nlockmgr
|   100021  1,3,4      33616/udp   nlockmgr
|   100021  1,3,4      43683/tcp6  nlockmgr
|   100021  1,3,4      57935/udp6  nlockmgr
|   100227  3           2049/tcp   nfs_acl
|   100227  3           2049/tcp6  nfs_acl
|   100227  3           2049/udp   nfs_acl
|_  100227  3           2049/udp6  nfs_acl
2049/tcp  open  nfs      3-4 (RPC #100003)
33513/tcp open  nlockmgr 1-4 (RPC #100021)
34027/tcp open  mountd   1-3 (RPC #100005)
36915/tcp open  mountd   1-3 (RPC #100005)
46773/tcp open  mountd   1-3 (RPC #100005)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.99%E=4%D=6/24%OT=22%CT=1%CU=39426%PV=Y%DS=3%DC=T%G=Y%TM=6A3B725
OS:9%P=x86_64-pc-linux-gnu)SEQ(SP=100%GCD=1%ISR=102%TI=Z%CI=Z%II=I%TS=A)SEQ
OS:(SP=103%GCD=1%ISR=10A%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=103%GCD=1%ISR=10B%TI=Z%
OS:CI=Z%II=I%TS=A)SEQ(SP=107%GCD=1%ISR=108%TI=Z%CI=Z%II=I%TS=A)SEQ(SP=108%G
OS:CD=1%ISR=10A%TI=Z%CI=Z%II=I%TS=A)OPS(O1=M4E8ST11NW7%O2=M4E8ST11NW7%O3=M4
OS:E8NNT11NW7%O4=M4E8ST11NW7%O5=M4E8ST11NW7%O6=M4E8ST11)WIN(W1=F4B3%W2=F4B3
OS:%W3=F4B3%W4=F4B3%W5=F4B3%W6=F4B3)ECN(R=Y%DF=Y%T=40%W=F507%O=M4E8NNSNW7%C
OS:C=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%
OS:T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD
OS:=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S
OS:=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK
OS:=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 3 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 8888/tcp)
HOP RTT      ADDRESS
1   75.86 ms 192.168.128.1
2   ...
3   72.53 ms 10.48.170.188

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 77.30 seconds

```

### Explanation for the sections 

#### Ports opened (2049 is of interest)

```bash 
PORT      STATE SERVICE  VERSION
22/tcp    open  ssh      OpenSSH 8.2p1 Ubuntu 4ubuntu0.13 (Ubuntu Linux; protocol 2.0)
111/tcp   open  rpcbind  2-4 (RPC #100000)
2049/tcp  open  nfs      3-4 (RPC #100003)
33513/tcp open  nlockmgr 1-4 (RPC #100021)
34027/tcp open  mountd   1-3 (RPC #100005)
36915/tcp open  mountd   1-3 (RPC #100005)
46773/tcp open  mountd   1-3 (RPC #100005)
```

These are the ports that are opened and the info in between was just i) the public keys ii) rcp info.
Also you can see `2049` is the port on which nfs is opened .

#### OS detection 

```bash
Network Distance: 3 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

```

This tells us about the OS its operating on .

#### Traceroute 

```bash 
TRACEROUTE (using port 8888/tcp)
HOP RTT      ADDRESS
1   75.86 ms 192.168.128.1
2   ...
3   72.53 ms 10.48.170.188
```

Not much info here 

### Mounting 

#### Get the mount share 

```bash
/usr/sbin/showmount -e 10.48.170.188(target ip)
```

O/P
```bash 
Export list for 10.48.170.188:
/home *
```
so we have the home folder to be mounted 

#### Mounting NFS shares

Your client’s system needs a directory where all the content shared by the host server in the export folder can be accessed. You can create this folder anywhere on your system. Once you've created this mount point, you can use the "mount" command to connect the NFS share to the mount point on your machine like so:

Make a tmp dir on your system first 
```bash
mkdir /tmp/mount && cd /tmp/mount
```

```bash 
sudo mount -t nfs IP:share /tmp/mount/ -nolock
```
IP - 10.48.170.188
share - /home
##### Explanation

|          |                                                                              |
| -------- | ---------------------------------------------------------------------------- |
| **Tag**  | **Function**                                                                 |
| sudo     | Run as root                                                                  |
| mount    | Execute the mount command                                                    |
| -t nfs   | Type of device to mount, then specifying that it's NFS                       |
| IP:share | The IP Address of the NFS server, and the name of the share we wish to mount |
| -nolock  | Specifies not to use NLM locking                                             |

#### Checking if it worked 

For this we have to check if the intended file was mounted to our system 
we can use `df (disk free)` command or the `mount` command 

```bash
┌──(krat_os㉿kratos)-[/tmp/mount]
└─$ df                                                       
Filesystem          1K-blocks     Used Available Use% Mounted on
udev                  7944116        0   7944116   0% /dev
tmpfs                 1621112     2144   1618968   1% /run
/dev/nvme0n1p5      102097848 38761220  58077572  41% /
tmpfs                 8105544    10988   8094556   1% /dev/shm
efivarfs                  192       64       124  35% /sys/firmware/efi/efivars
none                     1024        0      1024   0% /run/credentials/systemd-journald.service
/dev/loop6                128      128         0 100% /snap/bare/5
/dev/loop4              56832    56832         0 100% /snap/core18/2999
/dev/loop1              65408    65408         0 100% /snap/core20/2866
/dev/loop7              93952    93952         0 100% /snap/gtk-common-themes/1535
/dev/loop2              50560    50560         0 100% /snap/snapd/26865
/dev/loop3             506112   506112         0 100% /snap/code/243
/dev/loop5             168832   168832         0 100% /snap/gnome-3-28-1804/198
/dev/loop8              86528    86528         0 100% /snap/whatsapp-electron/23
/dev/loop0              75776    75776         0 100% /snap/core22/2411
tmpfs                 8105548      312   8105236   1% /tmp
/dev/nvme0n1p1         997456    35112    962344   4% /boot/efi
tmpfs                 1621108     4208   1616900   1% /run/user/1000
/dev/loop9             436224   436224         0 100% /snap/code/247
10.48.170.188:/home  10215936  6691328   2983936  70% /tmp/mount
```

as you can see the last entry 

`10.48.170.188:/home  10215936  6691328   2983936  70% /tmp/mount` 

or we can use the mount command 

```bash
┌──(krat_os㉿kratos)-[/tmp/mount]
└─$ mount | grep nfs                 
10.48.170.188:/home on /tmp/mount type nfs4 (rw,relatime,vers=4.2,rsize=262144,wsize=262144,namlen=255,hard,fatal_neterrors=none,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=192.168.159.65,local_lock=none,addr=10.48.170.188)
```

### Access the folders 
```bash
┌──(krat_os㉿kratos)-[/tmp/mount]
└─$ ls -la /tmp/mount
total 12
drwxr-xr-x  4 root    root    4096 Jun 22  2025 .
drwxrwxrwt 17 root    root     380 Jun 24 14:12 ..
drwxr-xr-x  5 krat_os krat_os 4096 Jun 22  2025 cappucino
drwxr-xr-x  4 thor    ironman 4096 Jun 22  2025 ubuntu
```


To get a remote access of the device in question we need ssh keys

```bash
┌──(krat_os㉿kratos)-[/tmp/mount/cappucino]
└─$ la
.bash_logout  .cache  .profile  .sudo_as_admin_successful
.bashrc       .gnupg  .ssh      .viminfo


┌──(krat_os㉿kratos)-[/tmp/mount/cappucino/.ssh]
└─$ la
authorized_keys  id_rsa  id_rsa.pub
```

Copy the `id_rsa` file on your local system 

```bash
┌──(krat_os㉿kratos)-[/tmp/mount/cappucino/.ssh]
└─$ cp ./id_rsa /home/krat_os/Desktop/Codex/THM/Network_services_2/Task3
```

Change the permissions to make it rw-

```bash
┌──(krat_os㉿kratos)-[~/…/Codex/THM/Network_services_2/Task3]
└─$ ll
total 4
-rw------- 1 krat_os krat_os 1679 Apr 22  2020 id_rsa
```

Now  use the ssh command to log into that user 

```bash 
ssh -i id_rsa cappucino@<targets ip>
```
