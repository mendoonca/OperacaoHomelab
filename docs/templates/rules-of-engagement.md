# Rules of Engagement (RoE) — Pentest Contoso Lda.

> Documento que define o âmbito e as regras do teste de intrusão. Preenche antes de começar.

## 1. Identificação

| Campo | Valor |
|---|---|
| Cliente | Contoso Lda. (fictício) |
| Executante | João Mendonça |
| Data de início | 2026-09-16 |
| Data de fim | AAAA-MM-DD |
| Tipo de teste | Grey-box (conhecimento parcial) |

## 2. Âmbito (In-scope)

| Ativo | IP / URL |
|---|---|
| Servidor web (DMZ) | 192.168.20.10 (portas 8080, 3000) |
| Rede interna (LAN) | 192.168.10.0/24 |
| Firewall | 192.168.10.1 |

## 3. Fora de âmbito (Out-of-scope)

- Máquina anfitriã (host físico).
- Internet real / qualquer sistema de terceiros.
- Ataques de negação de serviço (DoS) destrutivos.

## 4. Regras

- Testes realizados apenas na janela temporal acordada.
- Sem exfiltração de dados reais.
- Snapshots antes de ações potencialmente destrutivas.
- Todas as ações registadas no diário de bordo.

## 5. Contactos de emergência

| Papel | Nome | Contacto |
|---|---|---|
| Ponto de contacto | (o próprio) | jpmendonca505@gmail.com |

## 6. Autorização

Declaro que possuo autorização plena para testar os sistemas listados no âmbito, por serem propriedade minha e estarem isolados num laboratório.

Assinatura: João Mendonça  Data: 2026-09-16
