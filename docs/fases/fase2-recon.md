# Fase 2 — Reconhecimento e Enumeração

**Objetivo:** descobrir hosts, portas, serviços e superfícies de ataque, a partir do Kali.

⏱️ Duração estimada: 3–5 horas
🧰 Kali: nmap, whatweb, gobuster, nikto

---

## 2.1 — Descoberta de hosts

```bash
# Descobrir hosts vivos na DMZ
sudo nmap -sn 192.168.20.0/24
```

## 2.2 — Scan de portas e serviços

```bash
# Scan completo do alvo web, com deteção de versões e scripts default
sudo nmap -sV -sC -p- 192.168.20.10 -oN evidencias/fase2-recon/nmap-alvo.txt
```

Anota:
- Portas abertas (8080, 3000, SSH 22…).
- Versões dos serviços (procura CVEs conhecidos das versões encontradas).

## 2.3 — Enumeração web

```bash
# Identificar tecnologias
whatweb http://192.168.20.10:8080

# Fuzzing de diretórios/ficheiros
gobuster dir -u http://192.168.20.10:8080 \
  -w /usr/share/wordlists/dirb/common.txt \
  -o evidencias/fase2-recon/gobuster-dvwa.txt

# Scanner de vulnerabilidades web genérico
nikto -h http://192.168.20.10:8080 -o evidencias/fase2-recon/nikto-dvwa.txt
```

## 2.4 — Mapear a superfície do Juice Shop

O Juice Shop é uma SPA moderna. Explora com o browser + ferramentas de dev:
- Endpoints da API (`/api/...`, `/rest/...`).
- Usa o **Burp Suite** (incluído no Kali) para intercetar pedidos.

---

## 📋 Registar os findings

Para cada serviço/vulnerabilidade potencial, regista numa tabela (usa o [template de relatório](../templates/relatorio-pentest.md)):

| Host | Porta | Serviço | Versão | Observação |
|---|---|---|---|---|
| 192.168.20.10 | 8080 | HTTP (DVWA) | Apache 2.x | Login por defeito? |
| 192.168.20.10 | 3000 | HTTP (Juice Shop) | Node.js | API exposta |

---

## ✅ Checkpoint da Fase 2

- [ ] Output do nmap guardado em `evidencias/fase2-recon/`.
- [ ] Lista de serviços e versões.
- [ ] Diretórios interessantes encontrados (login, admin, uploads…).
- [ ] Tabela de superfície de ataque no diário/relatório.

### Diário de bordo
- Que portas te surpreenderam?
- Que hipóteses de ataque formaste a partir do recon?

➡️ Próxima: [Fase 3 — Exploração](fase3-exploitation.md)
