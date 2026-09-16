# 🛡️ Operação Homelab — Pentest a uma Empresa Fictícia

> Laboratório de cibersegurança completo, montado em casa, que documenta um ciclo real de **red team → relatório → remediação → deteção (blue team)** contra uma empresa fictícia (*Contoso Lda.*).

![Status](https://img.shields.io/badge/estado-em%20progresso-yellow)
![Focus](https://img.shields.io/badge/foco-web%20%7C%20rede%20%7C%20SIEM-blue)
![Lab](https://img.shields.io/badge/lab-VirtualBox%20%2B%20pfSense-informational)

---

## 📌 O que é este projeto

Este repositório documenta, de ponta a ponta, a construção de um laboratório de pentest doméstico e a realização de um teste de intrusão a uma infraestrutura fictícia. O objetivo não é só "atacar máquinas", mas demonstrar o **processo profissional completo**:

1. **Planeamento** — desenho da rede e definição de âmbito (*Rules of Engagement*).
2. **Construção** — montagem do lab em VMs, com segmentação de rede via pfSense.
3. **Ataque** — reconhecimento, enumeração e exploração (foco em aplicações web).
4. **Relatório** — documento profissional com findings, risco e evidências.
5. **Remediação** — correção das vulnerabilidades e novo teste de validação.
6. **Deteção** — demonstração, via SIEM (Wazuh), de que os ataques geram alertas.

---

## 🎯 Áreas de foco

- 🌐 **Pentest de aplicações web** — OWASP Top 10 no DVWA e OWASP Juice Shop.
- 🔀 **Redes e firewall** — desenho no Cisco Packet Tracer, implementação no pfSense (VLANs, ACLs, DMZ).
- 🔵 **Blue team / deteção** — Wazuh (SIEM) a detetar os ataques em tempo real.

---

## 🗺️ Arquitetura do laboratório

Laboratório otimizado para **16 GB de RAM** (ver [`docs/00-arquitetura.md`](docs/00-arquitetura.md) para detalhes e perfis de arranque).

```
                        INTERNET (NAT do host)
                               │
                        ┌──────┴───────┐
                        │   pfSense    │  Firewall / Router
                        │  (3 zonas)   │
                        └──┬────┬────┬─┘
              WAN ─────────┘    │    └───────── DMZ (192.168.20.0/24)
                                │                     │
                    LAN (192.168.10.0/24)      ┌──────┴────────┐
                          │                    │ Ubuntu Server │
                    ┌─────┴──────┐             │ DVWA + Juice  │
                    │ Wazuh SIEM │             │     Shop      │
                    │ (opcional) │             └───────────────┘
                    └────────────┘

              Kali Linux (atacante) — colocado na WAN ou numa VLAN dedicada
```

| VM | Zona | RAM | Função |
|---|---|---|---|
| **pfSense** | Firewall | 1 GB | Router/firewall entre WAN, LAN e DMZ |
| **Kali Linux** | Atacante | 3–4 GB | Máquina de ataque |
| **Ubuntu Server + DVWA/Juice Shop** | DMZ | 2 GB | Alvo web vulnerável |
| **Wazuh SIEM** | LAN | 4 GB | Deteção de ataques (liga só na Fase 6) |

⚠️ Com 16 GB, **não se corre tudo ao mesmo tempo**. Ver os [perfis de arranque](docs/00-arquitetura.md#perfis-de-arranque).

---

## 📂 Estrutura do repositório

```
operacao-homelab/
├── README.md                  ← estás aqui
├── docs/
│   ├── 00-arquitetura.md      ← desenho da rede, VMs, perfis de RAM
│   ├── fases/                 ← guia passo-a-passo de cada fase
│   │   ├── fase0-planeamento.md
│   │   ├── fase1-construcao.md
│   │   ├── fase2-recon.md
│   │   ├── fase3-exploitation.md
│   │   ├── fase5-remediacao.md
│   │   └── fase6-detecao.md
│   └── templates/             ← modelos reutilizáveis
│       ├── rules-of-engagement.md
│       ├── relatorio-pentest.md
│       └── diario-de-bordo.md
├── configs/                   ← ficheiros de configuração (pfSense, Wazuh, etc.)
├── scripts/                   ← scripts auxiliares
├── diagrams/                  ← topologias (Packet Tracer .pkt, imagens)
└── evidencias/                ← screenshots organizados por fase
```

---

## ⚠️ Aviso legal / ética

Todo o trabalho aqui documentado foi realizado **num ambiente isolado, contra máquinas propositadamente vulneráveis, propriedade do autor**. Nunca testar sistemas sem autorização escrita — em Portugal, o acesso ilegítimo a sistemas informáticos é crime (Lei do Cibercrime, Lei n.º 109/2009). Este repositório serve fins **exclusivamente educativos**.

---

## 👤 Autor

Projeto desenvolvido por **João Mendonça** como portfólio para funções em cibersegurança (pentesting / blue team).

📫 jpmendonca505@gmail.com

## 📄 Licença

Distribuído sob a licença MIT. Ver [`LICENSE`](LICENSE).
