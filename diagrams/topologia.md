# Topologia do Laboratório

Diagrama da rede (versão em texto/Mermaid). Guarda também aqui o ficheiro `.pkt` do Packet Tracer e uma imagem PNG exportada.

```mermaid
flowchart TB
    NET["🌐 Internet (NAT do host)"]
    FW["🛡️ pfSense<br/>Firewall / Router"]
    KALI["💻 Kali Linux<br/>Atacante"]
    UBU["🖥️ Ubuntu Server<br/>DVWA :8080 + Juice Shop :3000<br/>192.168.20.10"]
    WAZUH["🔵 Wazuh SIEM<br/>192.168.10.50"]

    NET --> FW
    KALI -->|WAN| FW
    FW -->|"DMZ 192.168.20.0/24"| UBU
    FW -->|"LAN 192.168.10.0/24"| WAZUH

    classDef red fill:#3a1a1a,stroke:#d66,color:#fff
    classDef blue fill:#1a2a3a,stroke:#69d,color:#fff
    classDef fw fill:#2a2a1a,stroke:#dd6,color:#fff
    class KALI red
    class WAZUH blue
    class FW fw
```

## Regras de firewall (resumo)

| Origem | Destino | Ação |
|---|---|---|
| WAN | DMZ (80/443) | Permitir |
| LAN | Qualquer | Permitir |
| DMZ | LAN | **Bloquear** |
| DMZ | WAN (updates) | Permitir |
