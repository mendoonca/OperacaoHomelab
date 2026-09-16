# Fase 5 — Remediação e Reteste

**Objetivo:** corrigir as vulnerabilidades encontradas e provar, com um novo teste, que ficaram resolvidas. Esta é a fase que **poucos portfólios têm** — e a que mais impressiona.

⏱️ Duração estimada: 4–6 horas

---

## 5.1 — Corrigir ao nível da aplicação

Para o DVWA, a "correção" é subir o nível de segurança para **High/Impossible** e mostrar que os ataques da Fase 3 deixam de funcionar. Explica *porquê*, ligando ao código:

| Vulnerabilidade | Correção real | Como o DVWA a demonstra |
|---|---|---|
| SQL Injection | Prepared statements / queries parametrizadas | Nível *Impossible* usa PDO com bind |
| XSS | Output encoding + Content-Security-Policy | Nível *High* aplica `htmlspecialchars` |
| File Upload | Validar tipo/extensão, guardar fora da webroot | Nível *High* verifica MIME e renomeia |
| Command Injection | Whitelist de input, evitar `shell_exec` | Nível *Impossible* valida o formato do IP |

## 5.2 — Corrigir ao nível da infraestrutura (hardening)

Aplica e documenta:

- **pfSense:** apertar regras (só as portas estritamente necessárias expostas na WAN).
- **Ubuntu:** `ufw` a limitar portas; atualizações (`apt upgrade`); remover o webshell.
- **Serviços:** desativar banners de versão; HTTPS em vez de HTTP.
- **Palavras-passe:** trocar credenciais por defeito.

Exemplo de firewall no servidor:
```bash
sudo ufw default deny incoming
sudo ufw allow 8080/tcp
sudo ufw allow 3000/tcp
sudo ufw enable
```

## 5.3 — Reteste

Volta a correr os ataques da Fase 3 e regista o resultado:

| Finding | Estado inicial | Ação de correção | Reteste |
|---|---|---|---|
| SQLi no login | Vulnerável | Prepared statements (nível Impossible) | ✅ Resolvido |
| Upload de webshell | Vulnerável | Validação de MIME + renomear | ✅ Resolvido |
| … | … | … | … |

> 📸 Guarda screenshots do **antes** (ataque funciona) e **depois** (ataque falha) em `evidencias/fase5-remediacao/`.

---

## ✅ Checkpoint da Fase 5

- [ ] Cada finding tem uma correção documentada.
- [ ] Hardening de rede e SO aplicado.
- [ ] Tabela de reteste preenchida.
- [ ] Evidências antes/depois.

➡️ Próxima: [Fase 6 — Deteção](fase6-detecao.md)
