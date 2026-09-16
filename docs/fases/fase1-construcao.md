# Fase 1 — Construção do Laboratório

**Objetivo:** montar o lab em VMs, com a pfSense a segmentar WAN / LAN / DMZ.

⏱️ Duração estimada: 6–10 horas
🧰 VirtualBox, ISOs de pfSense / Kali / Ubuntu

---

## 1.1 — Criar as redes no VirtualBox

Vais usar **redes internas** para isolar o lab do teu computador real.

No VirtualBox, cada VM terá adaptadores atribuídos a estas redes:

| Nome da rede interna | Uso |
|---|---|
| `wan` | Entre a pfSense e o atacante (Kali) |
| `lan` | Rede interna (Wazuh) |
| `dmz` | Servidor web |

> Para a pfSense ter internet real (para updates), o adaptador WAN pode ser **NAT** em vez de rede interna. Alternativa mais simples: WAN = NAT, e o Kali fica na LAN como "insider". Escolhe e **documenta a decisão**.

---

## 1.2 — Instalar a pfSense (a firewall)

1. Cria a VM: tipo *BSD / FreeBSD 64-bit*, 1 GB RAM, 8 GB disco.
2. Adiciona **3 adaptadores de rede**:
   - Adaptador 1 → NAT (WAN)
   - Adaptador 2 → Rede interna `lan`
   - Adaptador 3 → Rede interna `dmz`
3. Arranca com o ISO da pfSense e instala (aceita os defaults).
4. Na consola, atribui as interfaces:
   - WAN → `em0`
   - LAN → `em1` → `192.168.10.1/24`
   - OPT1 (DMZ) → `em2` → `192.168.20.1/24`
5. A partir de uma VM na LAN, acede à interface web: `https://192.168.10.1` (user `admin` / pass `pfsense`). **Muda a password.**

### Regras de firewall a criar

- **LAN → qualquer:** permitir (rede de gestão).
- **DMZ → LAN:** **bloquear** (regra explícita de `block`).
- **DMZ → WAN:** permitir HTTP/HTTPS/DNS (para updates).
- **WAN → DMZ:** permitir HTTP/HTTPS para o IP do servidor web (`192.168.20.10`) — simula a exposição pública.

> 📸 Guarda screenshots de cada regra em `evidencias/fase1-lab/`.

---

## 1.3 — Instalar o Ubuntu Server + alvos web (DMZ)

1. Cria a VM: Ubuntu 22.04, 2 GB RAM, 15 GB disco, adaptador na rede `dmz`.
2. IP estático `192.168.20.10/24`, gateway `192.168.20.1`.
3. Instala Docker (a forma mais limpa de correr os alvos):

```bash
sudo apt update && sudo apt install -y docker.io docker-compose
sudo usermod -aG docker $USER   # reinicia a sessão depois
```

4. Sobe os alvos vulneráveis com o compose incluído neste repo ([`configs/docker-compose-alvos.yml`](../../configs/docker-compose-alvos.yml)):

```bash
docker compose -f docker-compose-alvos.yml up -d
```

Isto expõe:
- **DVWA** em `http://192.168.20.10:8080`
- **OWASP Juice Shop** em `http://192.168.20.10:3000`

> ⚠️ No DVWA, define o nível de segurança em `Low` no início (para aprender), depois sobe para `Medium`/`High` para veres a diferença.

---

## 1.4 — Instalar o Kali (atacante)

1. Descarrega a imagem VirtualBox pré-feita do site da Kali (poupa a instalação).
2. RAM 3–4 GB, adaptador na rede `wan` (ou `lan`, conforme decidiste).
3. Confirma que alcanças o alvo:

```bash
ping 192.168.20.10
```

---

## 1.5 — (Adiar) Wazuh

Deixa o Wazuh para a Fase 6, para poupar RAM agora. Anota que a OVA all-in-one fica na rede `lan` com IP `192.168.10.50`.

---

## ✅ Checkpoint da Fase 1

- [ ] pfSense a encaminhar entre as 3 zonas.
- [ ] Regra DMZ→LAN a bloquear (testa com ping a partir do Ubuntu para a LAN — deve falhar).
- [ ] DVWA e Juice Shop acessíveis a partir do Kali.
- [ ] Snapshots de todas as VMs em estado limpo.
- [ ] Screenshots em `evidencias/fase1-lab/`.

➡️ Próxima: [Fase 2 — Reconhecimento](fase2-recon.md)
