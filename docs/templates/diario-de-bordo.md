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

*(continua a acrescentar entradas por baixo)*
