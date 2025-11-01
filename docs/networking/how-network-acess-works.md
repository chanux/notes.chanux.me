# How network access works

Working in a technical field means you'll eventually encounter network issues
that a simple restart can't fix. Understanding the fundamentals of network
access is crucial for troubleshooting these problems. This guide breaks down
the process of accessing a website, especially within a corporate environment
with strict network policies. My main objective of this write up is to make it
as simple as possible to follow and understand so it's accessible to someone
who is new to these concepts or found it unclear.

---

### Understanding the Basics of Network Access

When you type a domain name like `google.com` into your browser, the first step
is to translate that name into an **Internet Protocol (IP) address**. This is
handled by the **Domain Name System (DNS)**. Your computer asks a configured
DNS server for the IP address corresponding to the domain. In a corporate
setting, this request is often blocked by the company's DNS server, preventing
direct access to certain websites.

Even if you manage to find the correct IP address, you still need a **route**
to reach it. A route is a path that directs network traffic from your system to
the destination. Without a valid route, your system can't send data to the IP
address you've found. You can check the routing table on your system using
commands like `ip route` or `netstat -rn`.

Example:

To see the specific route to a destination IP, you can use the command:

```
ip route get <ip>
```

---

### Accessing Websites Through a Proxy

Since direct internet access is often restricted in corporate networks, you'll
likely need to use a **proxy server**. An **HTTP proxy** acts as an
intermediary, forwarding your requests to the internet on your behalf. It's
important to be mindful that HTTP proxies only handle traffic for the HTTP and
HTTPS protocols.

To use a proxy, your applications, like a web browser, must be configured to
send their requests through it.

#### Proxy Configuration

Modern web browsers like Firefox and Chrome can be configured to use a proxy
through their settings or by using a **Proxy Auto-Configuration (PAC)** file.
A PAC file contains logic that automatically selects the appropriate proxy
server based on the destination URL.

For other applications, you can typically configure a proxy by setting
environment variables such as `http_proxy` and `https_proxy`.

Example:

To set an HTTP proxy using an environment variable, you would use:

```
export http_proxy=127.0.0.1:3128
```

When your client application is configured with a proxy, it sends its request
(e.g., for `google.com`) to the proxy server instead of directly to the
website. The proxy server then fetches the content and returns it to your
client, provided that the request complies with the network's security
policies, if any.

---

### Bypassing the Proxy

Sometimes, you need to access resources on your internal network that do not
require a proxy. For these cases, you can use the `no_proxy` environment
variable. This setting tells your client applications to bypass the proxy for
specific hostnames or domains.

Example:

If you need to access a private server like `private-daily-checkin.company.net`
directly, you can set no_proxy to avoid sending that request to the proxy
server.

Keep in mind that some applications may only recognise the lowercase versions
of these variables (`http_proxy`, `https_proxy`, `no_proxy`), while others may
also support uppercase (`HTTP_PROXY`, `HTTPS_PROXY`, `NO_PROXY`). This
variability is common and is an important detail to remember when
troubleshooting.

---

### What to Expect with Network Commands

Given a scenario where your company laptop can only access an external website
via the corporate HTTP proxy, let's analyze what happens with various network
commands. You want to troubleshoot connectivity to a server hosted by a sister
company, located at `server.sistercompany.net`.

Consider the following commands:

- `ssh me@server.sistercompany.net`

- `telnet server.sistercompany.net 22`

- `telnet server.sistercompany.net 80`

- `nc server.sistercompany.net 22`

- `nc server.sistercompany.net 80`

- `curl -v telnet://server.sistercompany.net`

- `curl -v telnet://server.sistercompany.net:22`


The commands `ssh`, `telnet`, and `nc` (`netcat`) do not inherently support
HTTP proxies. They are designed for direct connections to a specific IP address
and port. Since your network requires an HTTP proxy for external access, these
commands will likely fail because they will NOT use the necessary proxy to
reach the destination.

The `curl` commands, however, are a bit different. By default, `curl` will try
to use the proxy settings if provided (ex: cli options,  environment
variables). The `telnet://` protocol specified in the `curl` command, to state
the obvious, is not standard HTTP, and curl will not HTTP proxy when handling
telnet requests. Therefore, these `curl` commands are also likely to fail. An
HTTP proxy is meant for HTTP/HTTPS traffic, not for generic TCP connections
like those initiated by `ssh` or `telnet`.

Once you have the basic idea, you can better appreciate the fact that the
connectivity methods mentioned above are in fact distinct protocols. Do take
a look at the specification documents, at least scan through. Do not be affraid
:)

- HTTP protocol RFC: [Hypertext Transfer Protocol -- HTTP/1.1](https://datatracker.ietf.org/doc/html/rfc2616)
- SSH protocol RFC: [The Secure Shell (SSH) Transport Layer Protocol](https://datatracker.ietf.org/doc/html/rfc4253)
- TELNET protocol RFC: [TELNET PROTOCOL SPECIFICATION](https://datatracker.ietf.org/doc/html/rfc854)
