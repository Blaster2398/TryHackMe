# TryHackMe - Task 6 (Backdoor Enumeration) Notes

## Goal

Find all open ports and identify what service is running on them.

Target:

10.49.138.89

---

# Step 1: Scan All Ports

Command:

```bash
nmap -Pn -p- 10.49.138.89
```

### Switches

`-Pn`

* Assume host is alive.
* Skip host discovery.

`-p-`

* Scan all 65535 TCP ports.

### Result

```text
PORT     STATE SERVICE
8012/tcp open  unknown
```

### Observation

* Only one port was open.
* Port 8012 is non-standard.
* Service could not be identified.

---

# Step 2: Investigate Open Port

Command:

```bash
nmap -Pn -sC -sV -p 8012 10.49.138.89
```

### Switches

`-sC`

* Run default NSE scripts.

`-sV`

* Service/version detection.

`-p 8012`

* Only investigate port 8012.

---

# Important Output

```text
SKIDY'S BACKDOOR. Type .HELP to view commands
```

### Observation

Nmap tried many protocol probes:

```text
HTTP
DNS
SMB
LDAP
RTSP
RPC
```

Every probe got the same response:

```text
SKIDY'S BACKDOOR. Type .HELP to view commands
```

### Conclusion

This is not a standard service.

It is a custom service / backdoor.

---

# Step 3: Banner Grabbing

Command:

```bash
nc -v 10.49.138.89 8012
```

### Why Netcat?

Think:

```text
Nmap = Find the door
Netcat = Talk through the door
```

---

# Banner

Output:

```text
SKIDY'S BACKDOOR. Type .HELP to view commands
```

### Definition

Banner:
Information a service reveals when a connection is established.

Examples:

```text
SSH-2.0-OpenSSH
220 FTP Server
SKIDY'S BACKDOOR
```

---

# Step 4: Enumerate Commands

Command entered:

```text
.HELP
```

Output:

```text
.HELP: View commands
.RUN <command>: Execute commands
.EXIT: Exit
```

### What We Learned

Available commands:

```text
.HELP
.RUN
.EXIT
```

Most important:

```text
.RUN <command>
```

suggests command execution capability.

---

# Key Concepts Learned

## Port Scan

Find open ports.

```bash
nmap -Pn -p- TARGET
```

---

## Service Enumeration

Identify service and version.

```bash
nmap -Pn -sC -sV -p PORT TARGET
```

---

## Banner Grabbing

Connect manually and inspect service response.

```bash
nc -v TARGET PORT
```

---

## Enumeration Workflow

```text
Find Port
↓
Identify Service
↓
Read Banner
↓
Enumerate Commands
↓
Infer Purpose
```

---

# Mental Model

Computer = Building

Port = Door

Nmap = Finds open doors

Netcat = Opens door and talks to service

Banner = Service introduces itself

Help Menu = Discover capabilities

Enumeration = Gather information before exploitation
