# Diário de Bordo

> Registo cronológico do projeto. Escreve entradas curtas e honestas — incluindo erros e como os resolveste. É isto que dá credibilidade ao portfólio e te prepara para responder a perguntas em entrevista.

---

## Modelo de entrada

### AAAA-MM-DD — [Fase X] Título curto

**O que fiz:**
-

**O que correu mal / o que aprendi:**
-

**Decisões tomadas (e porquê):**
-

**Próximo passo:**
-

---

## Entradas

### 2026-09-16 — [Fase 0] Desenho da rede no Packet Tracer

**O que fiz:**
- Desenhei a topologia da Contoso Lda. no Cisco Packet Tracer: 1 router (ISR 4331) como firewall/gateway, 2 switches (SW-LAN e SW-DMZ), 2 PCs de utilizador e 1 servidor web na DMZ.
- Configurei **VLANs** no SW-LAN: VLAN 10 (Users) e VLAN 99 (Management), com as portas dos PCs em modo *access* e a porta para o router em *trunk*.
- Implementei **router-on-a-stick** no R1, com subinterfaces `G0/0/0.10` (192.168.10.1) e `G0/0/0.99` (192.168.99.1), e a interface `G0/0/1` (192.168.20.1) para a DMZ.
- Criei uma **ACL** a bloquear a DMZ de iniciar ligações para a LAN e para a rede de gestão, aplicada à entrada da interface da DMZ.

**O que correu mal / o que aprendi:**
- O ping do router para o servidor da DMZ dava 0%. Ao configurar a interface da DMZ, apareceu o erro `% 192.168.20.0 overlaps with GigabitEthernet0/0/0.99`. Percebi, ao ler a mensagem e o `show ip interface brief`, que tinha atribuído por engano o IP da DMZ (192.168.20.1) à subinterface da VLAN 99, em vez de 192.168.99.1. Corrigi o IP da VLAN 99 e o conflito desapareceu, permitindo atribuir o endereço correto à DMZ.
- Confirmei também que o **primeiro pacote de um ping falha** (4/5 / 80%) por causa da resolução ARP inicial — é comportamento normal, não é falha de configuração.
- Aprendi na prática a diferença entre portas *access* e *trunk*, e porque o trunk é essencial no router-on-a-stick para transportar várias VLANs num só cabo.

**Decisões tomadas (e porquê):**
- Separei os Utilizadores (VLAN 10) da Gestão (VLAN 99) para reduzir a superfície de ataque e limitar o movimento lateral dentro da rede.
- Coloquei o servidor web numa **DMZ** isolada e bloqueei, na firewall, qualquer ligação iniciada da DMZ para a LAN — princípio de que um servidor exposto e eventualmente comprometido não deve conseguir alcançar a rede interna.

**Como validei:**
- `show ip interface brief` com todas as interfaces relevantes *up/up* e os IPs corretos.
- Ping de um PC da LAN (VLAN 10) para o servidor da DMZ: **com sucesso**.
- Ping do servidor da DMZ para a LAN: **bloqueado pela ACL** (comportamento esperado).

**Evidências guardadas:**
- `diagrams/contosoTopologia.pkt`
- Screenshots da topologia, do `show ip interface brief`, do `show vlan brief` e dos dois testes da ACL.
- `configs/r1-firewall-running-config.txt`

**Próximo passo:**
- Fase 1 — construir o laboratório real em VMs (VirtualBox, pfSense, Ubuntu + DVWA/Juice Shop, Kali).

---

### 2026-10-19 — [Fase 1] Construção do laboratório em VMs

**O que fiz:**
- Montei o laboratório completo no VirtualBox (host com 16 GB de RAM), com três redes: WAN (NAT), LAN (`192.168.10.0/24`) e DMZ (`192.168.20.0/24`).
- **pfSense (firewall):** instalei o pfSense CE 2.9.0 com três interfaces — WAN (em0), LAN (em1, `192.168.10.1`) e OPT1/DMZ (em2, `192.168.20.1`). Configurei DHCP na LAN e na DMZ, corri o Setup Wizard pelo browser e criei as regras de firewall da DMZ.
- **Kali (atacante):** importei a imagem pré-feita para a rede `lan`; recebeu IP por DHCP (`192.168.10.100`) e confirmei ligação ao gateway.
- **Ubuntu Server 26.04 (alvo web):** instalei na rede `dmz` com IP estático `192.168.20.10`, instalei o Docker e subi os alvos vulneráveis **DVWA** (porta 8080) e **OWASP Juice Shop** (porta 3000) via docker-compose.

**O que correu mal / o que aprendi:**
- **VT-x desativado:** a primeira VM não arrancava (`VT-x is disabled in the BIOS`). Tive de ativar a virtualização por hardware no BIOS/UEFI. Aprendi a confirmar o estado em Gestor de Tarefas → Desempenho → CPU → Virtualização.
- **Conectividade da DMZ e Apply Changes:** o maior problema desta fase foi o servidor da DMZ não chegar a lado nenhum (100% packet loss, nem ao gateway). O lado do Ubuntu estava correto (IP, rota default). O problema era na pfSense: as regras de firewall da interface OPT1 **não tinham sido aplicadas** (faltava carregar em "Apply Changes"). Percebi que a pfSense bloqueia todo o tráfego de uma interface nova até existirem regras **ativas**. Depois de aplicar, a conectividade passou a 0% loss.
- **Ordem das regras de firewall:** aprendi, na prática, que as regras são avaliadas de cima para baixo — a regra de *Block* (DMZ→LAN) tem de estar **acima** da de *Pass* (DMZ→Any), senão o "permitir tudo" apanha o tráfego primeiro.
- Escolhi o **Ubuntu Server** em vez do Desktop para poupar RAM (sem interface gráfica), decisão importante com apenas 16 GB.

**Decisões tomadas (e porquê):**
- WAN em NAT para a firewall ter internet (updates); Kali na LAN como "insider"; servidor web isolado na DMZ.
- Regra de firewall a **bloquear DMZ→LAN** e **DMZ→rede de gestão**, permitindo apenas DMZ→Internet — princípio de que um servidor exposto e comprometido não deve conseguir alcançar a rede interna.
- Alvos em **Docker** por ser a forma mais limpa e reprodutível de os correr e destruir.

**Como validei:**
- `ping` do servidor da DMZ ao gateway (`192.168.20.1`) e à internet (`8.8.8.8`, `google.com`) — todos com 0% loss após aplicar as regras.
- `docker ps` com os dois containers (dvwa, juiceshop) em estado *Up*.
- A partir do **Kali (LAN)**, acesso via browser ao **DVWA** (`http://192.168.20.10:8080`) e ao **Juice Shop** (`http://192.168.20.10:3000`), provando a cadeia Kali → firewall → DMZ.

**Evidências guardadas:**
- Screenshots: estado das 3 interfaces da pfSense, regras de firewall OPT1, `docker ps`, testes de ping (antes/depois do Apply Changes), DVWA e Juice Shop abertos no Kali.
- Snapshots das VMs em estado limpo: pfSense, Kali, Ubuntu-WebServer.

**Próximo passo:**
- Fase 2 — Reconhecimento e Enumeração (nmap, whatweb, gobuster, nikto) a partir do Kali contra o alvo `192.168.20.10`.

---

*(continua a acrescentar entradas por baixo)*
