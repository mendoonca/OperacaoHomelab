# 00 — Arquitetura do Laboratório

Este documento explica o desenho da rede, as VMs e como geri-las com apenas **16 GB de RAM**.

---

## 1. Cenário fictício — Contoso Lda.

A *Contoso Lda.* é uma PME fictícia com:

- Um **servidor web** exposto na internet (loja online + portal interno) → **DMZ**.
- Uma **rede interna** de utilizadores e serviços → **LAN**.
- Uma **firewall** a separar tudo → **pfSense**.

O nosso papel: fomos contratados para fazer um **pentest externo e interno** e entregar um relatório.

---

## 2. Topologia

```
                        INTERNET (NAT do host / adaptador em ponte)
                               │
                        ┌──────┴───────┐
                        │   pfSense    │
                        │  WAN / LAN / OPT1(DMZ)
                        └──┬────┬────┬─┘
                           │    │    │
        WAN 10.0.2.0/24 ───┘    │    └─── DMZ (OPT1) 192.168.20.0/24
        (rede "internet"        │              │
         onde vive o Kali)      │        ┌─────┴─────────┐
                                │        │ Ubuntu Server │ .10
                     LAN 192.168.10.0/24 │ DVWA + Juice  │
                          │              └───────────────┘
                    ┌─────┴──────┐
                    │ Wazuh SIEM │ .50
                    └────────────┘
```

### Endereçamento sugerido

| Interface pfSense | Rede | IP pfSense |
|---|---|---|
| WAN | 10.0.2.0/24 (NAT) | atribuído por DHCP do host |
| LAN | 192.168.10.0/24 | 192.168.10.1 |
| OPT1 (DMZ) | 192.168.20.0/24 | 192.168.20.1 |

| VM | Rede (VirtualBox) | IP |
|---|---|---|
| Kali | "internet"/WAN | DHCP |
| Ubuntu web | DMZ | 192.168.20.10 |
| Wazuh | LAN | 192.168.10.50 |

> No VirtualBox usa **redes internas** ("Internal Network") com nomes distintos: `wan`, `lan`, `dmz`. A pfSense terá 3 adaptadores, um em cada uma.

---

## 3. VMs e requisitos

| VM | ISO / fonte | RAM | Disco | vCPU |
|---|---|---|---|---|
| **pfSense CE** | pfsense.org (Community Edition) | 1 GB | 8 GB | 1 |
| **Kali Linux** | kali.org (imagem VirtualBox pré-feita) | 3–4 GB | 30 GB | 2 |
| **Ubuntu Server 22.04** | ubuntu.com | 2 GB | 15 GB | 1 |
| **Wazuh (OVA all-in-one)** | wazuh.com | 4 GB | 30 GB | 2 |

---

## 4. Perfis de arranque

Com 16 GB, reserva **~4 GB para o host**. Nunca ligues tudo. Usa estes perfis:

### 🟢 Perfil A — Rede + Web (Fases 1 a 5)
`pfSense (1) + Kali (4) + Ubuntu web (2)` = **~7 GB** → sobra folga.

### 🔵 Perfil B — Deteção (Fase 6)
`pfSense (1) + Kali (3) + Ubuntu web (2) + Wazuh (4)` = **~10 GB** → apertado mas funciona. Baixa o Kali para 3 GB e fecha o browser do host.

> 💡 Dica: tira **snapshots** de cada VM em estado limpo antes de começar cada fase. Assim recuperas em segundos se algo correr mal.

---

## 5. Software necessário (no host)

- **VirtualBox** (gratuito) ou **VMware Workstation Pro** (agora gratuito para uso pessoal).
- **Cisco Packet Tracer** (gratuito com conta Cisco NetAcad) — só para o desenho da Fase 0.
- Cliente SSH (o terminal do Windows/Linux/macOS já chega).

---

## 6. Porque esta arquitetura

- **DMZ separada da LAN** → replica uma empresa real e obriga-te a configurar regras de firewall (mostra competência de rede).
- **Kali fora da LAN** → simulas primeiro um atacante externo, depois movimento para dentro.
- **Wazuh na LAN** → o SIEM vê o tráfego interno e recebe logs dos alvos.

Próximo passo: [Fase 0 — Planeamento](fases/fase0-planeamento.md).
