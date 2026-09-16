# Fase 0 — Planeamento e Desenho (Cisco Packet Tracer)

**Objetivo:** desenhar a rede da Contoso Lda. e definir formalmente o âmbito do teste, tal como se faz num pentest real.

⏱️ Duração estimada: 3–5 horas
🧰 Ferramentas: Cisco Packet Tracer

---

## 0.1 — Definir as Rules of Engagement (RoE)

Antes de qualquer ferramenta, preenche o template [`docs/templates/rules-of-engagement.md`](../templates/rules-of-engagement.md). Este documento define:

- **Âmbito (scope):** que IPs/redes podem ser testados (ex.: `192.168.20.0/24` e `192.168.10.0/24`).
- **Fora de âmbito:** o próprio host, a internet real.
- **Janela temporal, tipo de teste** (grey-box), e regras (ex.: sem DoS destrutivo).

> 📸 **Evidência:** guarda o RoE preenchido. Num relatório real, é a primeira secção.

---

## 0.2 — Desenhar a topologia no Packet Tracer

O Packet Tracer **não corre os ataques**, mas é perfeito para mostrar que sabes desenhar e configurar uma rede empresarial segmentada.

### Passos

1. Abre o Packet Tracer e coloca:
   - 1 **router** (ex.: 1941) a fazer de gateway / representação da pfSense.
   - 1 **switch** (2960) para a LAN.
   - 1 **switch** para a DMZ.
   - 2–3 **PCs** na LAN e 1 **server** na DMZ.

2. Cria **VLANs** no switch da LAN:
   - `VLAN 10` — Utilizadores
   - `VLAN 20` — Servidores
   - `VLAN 99` — Gestão (Management)

3. Configura **router-on-a-stick** (subinterfaces com `encapsulation dot1Q`).

4. Aplica **ACLs** para simular a firewall:
   - LAN → DMZ: permitir só HTTP/HTTPS.
   - DMZ → LAN: **negar** (a DMZ nunca deve iniciar ligações para dentro).

### Exemplo de configuração (router)

```
enable
configure terminal
!
interface g0/0.10
 encapsulation dot1Q 10
 ip address 192.168.10.1 255.255.255.0
!
interface g0/0.20
 encapsulation dot1Q 20
 ip address 192.168.20.1 255.255.255.0
!
! ACL: DMZ não pode iniciar ligações para a LAN
access-list 110 deny ip 192.168.20.0 0.0.0.255 192.168.10.0 0.0.0.255
access-list 110 permit ip any any
!
interface g0/0.20
 ip access-group 110 in
```

5. Testa a conectividade com `ping` no modo simulação e confirma que as ACLs bloqueiam o que devem bloquear.

---

## ✅ Checkpoint da Fase 0

- [ ] RoE preenchido e guardado em `evidencias/`.
- [ ] Ficheiro `.pkt` guardado em `diagrams/contoso-topologia.pkt`.
- [ ] Screenshot da topologia guardado.
- [ ] Screenshots a mostrar as ACLs a funcionar (ping bloqueado/permitido).

### O que escrever no diário de bordo

- Que decisões de segmentação tomaste e **porquê** (ex.: "separei servidores dos utilizadores para limitar movimento lateral").
- Dificuldades com o router-on-a-stick e como as resolveste.

➡️ Próxima: [Fase 1 — Construção](fase1-construcao.md)
