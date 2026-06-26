```
1. Find exposed services
        ↓
2. Enumerate them
        ↓
3. Identify misconfigurations or vulnerabilities
        ↓
4. Gain access
        ↓
5. Escalate privileges
```


|Service/Room|What We Learned|Tools/Commands Used|Key Takeaway|
|---|---|---|---|
|**SMB (Server Message Block)**|Enumerate shares, users, and access permissions|`nmap`, `enum4linux`, `smbclient`|Misconfigured shares can leak sensitive files like SSH keys and user information.|
|**Telnet Backdoor**|Enumerate non-standard ports and interact with custom services|`nmap -p-`, `nc`, `telnet`, `tcpdump`, `msfvenom`|Always investigate unknown open ports; they may provide command execution or reverse shells.|
|**SMTP (Mail Service)**|Enumerate mail server information and valid users|`nmap`, `msfconsole`, `smtp_version`, `smtp_enum`|Information leakage from services can reveal usernames, server versions, and software.|
|**MySQL**|Authenticate to databases and enumerate stored information|`mysql`, Metasploit `mysql_sql`|Databases often contain sensitive information and can reveal system details.|
|**NFS (Network File System)**|Enumerate exports, mount remote shares, and access remote files|`showmount`, `mount`, `scp`, `ssh`|An exposed NFS share can expose entire directories and user credentials.|
|**NFS Privilege Escalation**|Exploit `no_root_squash` to obtain root privileges|`chmod`, `chown`, `ssh`, SUID|Misconfigured NFS permissions can allow a low-privilege user to escalate to root.|
|**SSH**|Authenticate using SSH keys instead of passwords|`ssh`, `scp`|Exposed private keys can completely bypass password authentication.|
|**General Enumeration Workflow**|Develop a structured attack methodology|`nmap`, service-specific tools|**Enumerate → Identify → Exploit → Escalate** is the standard workflow in penetration testing.|