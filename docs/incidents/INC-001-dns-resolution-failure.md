# INC-001 — Active Directory DNS resolution failure

| Field | Detail |
|---|---|
| Type | Simulated help desk incident based on a real problem during this lab build |
| Category | DNS / Windows networking / Active Directory |
| Priority | P3 (simulated lab classification, not an actual service SLA) |
| Status | Resolved and validated |
| System | CLIENT01 — Windows 11 Pro |
| Server | DC01 — Windows Server 2025 (`192.168.184.10`) |
| Domain | `corp.tetsalab.test` |

## Issue / impact

While preparing CLIENT01 to join the Active Directory domain, a DNS name-resolution test failed. CLIENT01 was configured to use its own IP address (`192.168.184.20`) as its preferred DNS server rather than DC01 (`192.168.184.10`). This prevented CLIENT01 from locating the DNS service used for AD domain discovery.

## Investigation

1. Verified network settings and connectivity using `ipconfig /all` and ping.
2. Identified the preferred DNS setting of `192.168.184.20` on CLIENT01.
3. Confirmed DC01's DNS service was responding, including AD SRV records.
4. Changed CLIENT01's preferred DNS to `192.168.184.10`.
5. Cleared the client's resolver cache and reran the hostname lookup.
6. Completed the domain join and independently verified membership.

```powershell
Get-DnsClientServerAddress -AddressFamily IPv4
ipconfig /flushdns
Resolve-DnsName dc01.corp.tetsalab.test
Get-CimInstance Win32_ComputerSystem | Select-Object Name,Domain,PartOfDomain
```

## Root cause

**Incorrect client-side DNS server configuration**: CLIENT01 was set to use itself instead of the AD DNS server at DC01.

## Resolution and validation

DNS was corrected to `192.168.184.10`. CLIENT01 resolved `dc01.corp.tetsalab.test` to that address and successfully joined `corp.tetsalab.test`. `Get-CimInstance Win32_ComputerSystem` returned `PartOfDomain = True`.

## Evidence

- [Initial incorrect DNS setting](../../screenshots/04-client01-static-ip-configuration.png)
- [Successful DNS resolution](../../screenshots/14-client01-dns-resolution.png)
- [Successful domain join](../../screenshots/16-successful-domain-join.png)
- [Verified computer membership](../../screenshots/17-client01-domain-membership.png)

## Prevention / closure

Standardize domain client DNS settings, preferably through centrally managed network configuration where applicable. Include AD DNS lookup tests in domain-join troubleshooting. **Status: Closed (lab simulation).**
