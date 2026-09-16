# Roteiro / Checklist geral

Acompanha o progresso do projeto. Marca à medida que avanças.

## Fase 0 — Planeamento
- [ ] Rules of Engagement preenchidas
- [ ] Topologia desenhada no Packet Tracer
- [ ] VLANs + ACLs configuradas e testadas
- [ ] `.pkt` e screenshots guardados

## Fase 1 — Construção
- [ ] Redes internas criadas no VirtualBox
- [ ] pfSense instalada e a segmentar 3 zonas
- [ ] Regras de firewall (DMZ→LAN bloqueada)
- [ ] Ubuntu + DVWA + Juice Shop a correr
- [ ] Kali a alcançar os alvos
- [ ] Snapshots limpos

## Fase 2 — Reconhecimento
- [ ] Descoberta de hosts
- [ ] nmap completo guardado
- [ ] Enumeração web (gobuster, nikto, whatweb)
- [ ] Tabela de superfície de ataque

## Fase 3 — Exploração
- [ ] SQLi, XSS, upload, command injection (DVWA)
- [ ] 3+ desafios do Juice Shop
- [ ] Findings com CVSS e evidências

## Fase 5 — Remediação
- [ ] Correção por finding documentada
- [ ] Hardening de rede e SO
- [ ] Reteste (antes/depois)

## Fase 6 — Deteção
- [ ] Wazuh a funcionar
- [ ] Agente ativo
- [ ] Ataques detetados + FIM + MITRE

## Entrega final
- [ ] Relatório de pentest completo
- [ ] Diário de bordo preenchido
- [ ] README revisto
- [ ] Repositório publicado no GitHub

---

## 💡 Dicas para o GitHub / entrevistas

- **Commits frequentes e descritivos** — mostram o processo, não só o resultado.
- Adiciona um **GIF ou vídeo curto** de um ataque em ação no README.
- Escreve o relatório também em **PDF** para anexar a candidaturas.
- Prepara-te para explicar **uma vulnerabilidade a fundo** e **um ataque que o Wazuh não detetou** — são perguntas típicas de entrevista.
- Liga o projeto ao teu LinkedIn com um post a resumir o que aprendeste.
