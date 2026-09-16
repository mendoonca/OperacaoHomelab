# Fase 6 — Deteção (Blue Team com Wazuh)

**Objetivo:** instalar um SIEM (Wazuh), ligar os alvos como agentes, repetir os ataques e mostrar que geram **alertas**. Prova que sabes olhar dos dois lados.

⏱️ Duração estimada: 5–8 horas
🧰 Wazuh (OVA all-in-one), agentes Wazuh no Ubuntu

> 💾 **RAM:** usa o Perfil B (ver arquitetura). Baixa o Kali para 3 GB e fecha aplicações do host.

---

## 6.1 — Instalar o Wazuh

1. Importa a **OVA all-in-one** do Wazuh no VirtualBox (Wazuh manager + indexer + dashboard num só).
2. Adaptador na rede `lan`, IP `192.168.10.50`.
3. Acede ao dashboard: `https://192.168.10.50` (credenciais mostradas no primeiro arranque).

> Se 4 GB for demais, considera instalar só o `wazuh-manager` numa VM leve e ver alertas por linha de comando — mas o dashboard dá screenshots muito melhores para o portfólio.

## 6.2 — Instalar o agente no alvo (Ubuntu web)

No dashboard Wazuh → *Add agent* → segue o comando gerado, algo como:
```bash
curl -so wazuh-agent.deb https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.x.deb
sudo WAZUH_MANAGER='192.168.10.50' dpkg -i ./wazuh-agent.deb
sudo systemctl enable --now wazuh-agent
```

Confirma no dashboard que o agente aparece como *Active*.

## 6.3 — Gerar e detetar ataques

Repete ataques da Fase 3 e observa os alertas:

| Ataque | O que o Wazuh deteta |
|---|---|
| Brute-force SSH (`hydra`) | Regras de autenticação falhada, alerta de brute-force |
| Scan nmap | Picos de ligações / port scan |
| Upload de webshell + acesso | Alterações a ficheiros (FIM) na webroot |
| Command injection | Comandos suspeitos nos logs |

Exemplo de brute-force para gerar alertas:
```bash
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://192.168.20.10
```

### File Integrity Monitoring (FIM)
Ativa o FIM na diretoria de uploads para detetar o webshell. No `ossec.conf` do agente:
```xml
<syscheck>
  <directories check_all="yes" realtime="yes">/var/www/html/hackable/uploads</directories>
</syscheck>
```

## 6.4 — Mapear ao MITRE ATT&CK

O Wazuh já mapeia muitos alertas a técnicas MITRE. Faz screenshot do módulo MITRE ATT&CK a mostrar as técnicas detetadas — fica excelente no relatório.

---

## ✅ Checkpoint da Fase 6

- [ ] Wazuh a funcionar com o dashboard acessível.
- [ ] Agente ativo no alvo.
- [ ] Pelo menos 3 tipos de ataque com alerta correspondente (screenshot).
- [ ] FIM a apanhar o webshell.
- [ ] Mapeamento MITRE ATT&CK capturado.

### Diário de bordo
- Que ataques **não** foram detetados? Porquê? (excelente reflexão para uma entrevista)
- Que regras personalizadas criaste?

➡️ Fim do ciclo técnico. Agora fecha o [relatório de pentest](../templates/relatorio-pentest.md).
