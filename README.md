# fpejril/homelab

This repository serves to document my homelab journey. As with any good homelab, the structure may change and evolve over time, and the components used may change as well.

## Why a homelab?

The main goal of my homelab thus far has been to repurpose the hardware I already have for learning and experimentation. I generally avoid purchasing new hardware unless absolutely necessary, so aside from the hardware I already had, the only upgrade I've made to my homelab has been filling out my DIMM slots with an additional 32 GiB of memory.

I love to learn, and I love tinkering, so my journey with this so far has been a lot of fun, but also a lot of building things up and tearing them down.

I've worked in cloud operations for a long time now -- about 9 years, to be exact -- but aside from local development on my laptop, I haven't really done much with my own hardware until I started homelabbing. In that time, my MacBook -- which has been "upgraded" (replaced) over time -- has served as my main workstation, used for local development/testing and as my point of entry into cloud environments. Meanwhile, my Desktop PC collected dust. For a long time I was a PC gamer, but as the time I've had for gaming has decreased, I found myself increasingly leaning toward consoles, since the cost of hardware for modern PC gaming has increased **a lot** over time, and the need for tinkering with settings hasn't changed much. I want gaming to be relaxing, so I've designated computers for work & learning, and consoles for gaming.

## What am I doing?

Fast-forward to today, and with my spare time I've taken to tinkering with that old desktop -- as well as some of my older MacBooks. I've tried a few things on the Desktop -- I started trying out different Linux desktop distributions (my current favorite being the tried and true Ubuntu Desktop), and spinning up containerized applications to tinker with.

The community at [r/homelab](https://www.reddit.com/r/homelab/) definitely has some strong opinions about what works and what doesn't, and so I've leaned into the community suggestions as I learn new tools and make the _tough_ choices of which FOSS solution best fits my purposes.

This is definitely a Linux-first homelab. In my day job I've mostly used AWS and RHEL-based distributions (Amazon Linux), so I have had a _lot_ of hands-on experience managing and maintaining Linux servers. I've never used Linux much for my own purposes, though. My experience with networking and server provisioning was strictly limited to EC2, RDS, VPC and the like. I maintain that the cloud is where we should be for business and enterprise deployments -- at least if you're working with lean resources in engineering operations -- but as I've learned more, I have become a big advocate of self-hosting as well.

While I'm not quite there yet, the end-goal of this homelab is to self-host publicly available services which are secure enough that I can have the confidence to host them from my own home.

## Some Background

I think the most important parts of any good software are:

1. A thriving community
2. Solid documentation

Because of this, I've leaned a lot into the homelabbing community and their findings, testing, and solutions as I build out my homelab.

## What's in my homelab?

My homelab serves mainly to repurpose my old hardware, and so is primarily hosted from a single desktop computer. Scream all you'd like -- this is the hardware I have, and I'm not trying to break the bank until I'm limited by what I have. Thus far, I've found that there's nearly nothing I can't do with a little elbow grease.

### Hardware
My main "server" is a Proxmox VE hypervisor, sitting on my home-built desktop with:

- **Processor**: Intel Core i5-12600KF
- **Motherboard**: MSI PRO Z790 WiFi
- **Memory**: 64GB, DDR5 @ 6400MHz
- **GPU**: Nvidia GTX 1070 8GB

This is connected to my home network directly, as I didn't have any kind of complex networking set up to begin with (just what my ISP provides), but at present is inaccessible from the public internet.

I also have a couple of old laptops -- a 2014 MacBook Pro, and a 2015 MacBook Air -- which I've installed Ubuntu Desktop onto (_so much better than macOS for old hardware_). I'm still not sure what I'll do with them -- I can't very well include them in my homelab without a switch -- but Linux give me the freedom to do great things with them eventually! I'll probably end up with something else on them in the end.

### Software

Proxmox serves as a great testing ground for all kinds of applications, and I've tried a lot of things. Once I found [Proxmox VE Helper-Scripts](https://community-scripts.github.io/ProxmoxVE/) (thank you so much, and rest easy, [tteck](https://github.com/tteck)), the boundaries of what I can do have all but disappeared. I do think I'll eventually move away even from this as a solution -- right now I'm working on setting up a Kubernetes cluster -- but it has been invaluable in setting up my basic infrastructure.

Here's what I have running as of writing (May 2025):

#### pfSense (VM)

This serves as the primary router and firewall for all other VMs and LXCs in my homelab. It manages a single LAN on a virtual bridge, from which I've configured several VLANs for isolation. Aside from the Proxmox host itself, this is the only other device which connects to my home network. 
  
While I can set up static IP claims in Proxmox directly, I've found that I prefer to instead make DHCP reservations for my other devices in pfSense.

#### Wireguard (LXC)

Perhaps self-explanatory, but this serves as the point of entry from my home network and remote networks into my homelab. The helper script for this also includes [WGDashboard](https://github.com/donaldzou/WGDashboard), which has some downsides but overall makes working with Wireguard _much more pleasant_.

#### Pi-hole (LXC)

This not only serves as a DNS-based ad-blocker, but a very user-friendly solution for setting up local DNS records (including CNAME records -- which is why I chose this over DNS in pfSense). I have configured DNS records for all of my "permanent" web interfaces in the [fplabs.lan]() domain, and configured this as the primary DNS server to be served via DHCP to all clients in my LAN and VLANs.

#### Nginx Proxy Manager (LXC)

I've configured Nginx as a reverse proxy more times than I can count, but NPM makes it so easy to configure basic reverse proxies for my homelab. It has many limitations that make it not as robust as a pure Nginx implementation, but for my purposes, thus far it has been a great solution.

#### Beszel (LXC)

I'm planning to move away from this and to a more robust solution like Zabbix or a Prometheus/Grafana stack. However, it's still a great (if not robust) solution for monitoring my LXC and VM hosts. I originally found this when I was testing out CasaOS, and it's a neat little monitoring tool.

#### Windows 11 (VM)

I didn't want to totally ditch Windows on my Desktop -- there's still some great software which runs best (or only) on Windows. With GPU passthrough, my Proxmox host nearly invisibly boots into Windows 11, and aside from the fact that I'm only giving it a fraction of the CPU/Memory on the host, you probably wouldn't be able to tell that it's running in a VM. 

I haven't used this all that much aside from getting it working "flawlessly" (as far as I have tested), but I'm very grateful to be able to have the best of both worlds!

Since my GPU is fully allocated to the Windows host, this is also where I'm running Ollama for use by...

#### Open WebUI (LXC)

I like playing around with AI, and the fact that I can run the latest models like Llama3.2, Qwen3 and Gemma3 on a GPU from 2016 is pretty cool! I will still probably lean toward ChatGPT and Gemini for most things AI -- as I'm not ready to foot the bill to run my own web search implementation, and the free tiers are still better than what I can run at home -- but I still think this is really cool. I'm planning to move it into...

#### Kubernetes (VMs)

Most recently I've started working on my own Kubernetes cluster. I'm not too far along yet, and maybe I should have used k3s like so many others suggest. However, I've set up a four-node k8s cluster on Ubuntu 24.04 VMs (2 CPU, 4 GiB each) and I'm testing out various deployments on it.

I'll probably make different choices as I learn more, but right now I'm using:

- **Network**: `flannel`
- **StorageClass**: `local-path-storage`
- **IngressClass**: `ingress-nginx`
- **LoadBalancer**: `metallb`

Other than this basic fabric, I'm also playing around right now with [prometheus-community/kube-prometheus-stack](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack).

## Network Topology

```
                                 [ Internet ]
                                     │
                                  Public IP
                                     │
                        [ Home Network Router / WAP ]
                                  Home LAN
                                    │
               ┌────────────────────┴────────────────────┐
               │                                         │
      [ Proxmox Host ]                          Other Home Devices
               │                                 (DHCP clients)
         vmbr0 (Home LAN bridge)
               │
    ┌──────────┴──────────┐
    │                     │
[ pfSense VM ]         [ Other VMs / Containers on vmbr0 ]
    - WAN (bridged to vmbr0)
    - LAN: 10.42.1.1/24
    - VLAN-aware on vmbr1
    - Port Forwarding: WG port
    │
    ├── vmbr1 (VLAN-aware bridge) ─────────────────────────────────────┐
    │                                                                  │
    │                          Homelab LAN (10.42.1.0/24)              │
    │    ┌────────────────────────────┬────────────────────────────┬───┴────────────────────┐
    │    │                            │                            │                        │
[ Wireguard Container ]    [ Pi-hole Container ]     [ Nginx Proxy Manager ]       [ Others... ]
  - IP: 10.42.1.2             - IP: 10.42.1.3              - IP: 10.42.1.5
  - wg0: 10.0.0.1/24          - DNS: fplabs.lan            - HTTPS reverse proxy
  - Forwards to LAN
    │
    ├── VLANs on vmbr1 (broadcasted by pfSense) ─────────────────────────────────────────────┐
    │                                                                                        │
    │   VLAN 10 (DMZ):   10.42.2.1/24   ──► Publicly exposed services                        │
    │   VLAN 20 (K8S):   10.42.3.1/24   ──► Kubernetes cluster                               │
    │   VLAN 30 (TEST):  10.42.4.1/24   ──► General experimentation                          │
    │                                                                                        │
    └────────────────────────────────────────────────────────────────────────────────────────┘
                                 ▲
                                 │
                        [ Wireguard Clients]
                         Connect to WAN IP:WG Port
                               ↓
                    Port forwarded by Home Network → pfSense → Wireguard
                    Remote clients reach: 10.42.0.0/16, 10.0.0.0/24, Home Network
```