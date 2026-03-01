# Postman Collection - Best Practices & Modularization Guide

## Overview
Esta coleção ServeRest foi criada para testes de API com relatórios Allure + HTML. 
Este guia descreve as estratégias de organização implementadas e como mantê-las.

---

## 1. Estrutura de Testes em 3 Níveis

### Nível 1: Collection (Global)
**Localização:** `event > test` no nível `collection`

**Responsabilidade:** Testes comuns a **todos** os requests
```javascript
// Executado após cada request
pm.test('Response time < 3000ms', function () {
  pm.expect(pm.response.responseTime).to.be.below(3000);
});

pm.test('Tem header Content-Type quando há body', function () {
  if (pm.response.text()) {
    pm.expect(pm.response.headers.get('Content-Type')).to.exist;
  }
});
```

**Vantagem:** Evita repetição, garante consistência.

---

### Nível 2: Request Individual
**Localização:** `item[n] > event > test`

**Responsabilidade:** Testes específicos do endpoint
```javascript
const json = pm.response.json();

pm.test('Schema básico: contém message', function () {
  pm.expect(json).to.have.property('message');
});

pm.test('Status code é 200', function () {
  pm.response.to.have.status(200);
});
```

**Nota:** Removemos `Status` e `Content-Type` daqui (já rodando globalmente).

---

### Nível 3: Pre-request (Setup)
**Localização:** `item[n] > event > prerequest`

**Responsabilidade:** Preparar dados, headers, variáveis antes de enviar
```javascript
// Exemplo: garantir que token existe
pm.test("userId existe no environment", () => {
  pm.expect(pm.environment.get("userId")).to.be.ok;
});
```

---

## 2. Padrões de Validação Robusta

### ✅ Bom: Regex Flexível
```javascript
// Aceita múltiplas variações da mensagem
pm.expect(json.message).to.match(/excluído|nenhum/i);
```

### ❌ Evitar: Regex Muito Restritiva
```javascript
// Falha se a mensagem variar mesmo que válida
pm.expect(json.message).to.match(/^Registro excluído com sucesso$/);
```

---

## 3. Checklist de Refatoração para Novos Requests

Ao adicionar ou modificar um request:

- [ ] **Pre-request script:**
  - Validar variáveis necessárias (token, IDs, etc.)
  - Gerar dados aleatórios se necessário (emails, timestamps)
  
- [ ] **Request Body:**
  - Usar `{{variableNames}}` para dados dinâmicos
  - Evitar hardcoding de valores
  
- [ ] **Test script:**
  - NÃO duplicar testes de `Status` ou `Content-Type` (já globais)
  - Focar em validações específicas do endpoint
  - Usar regex flexível para mensagens
  - Parsear JSON uma única vez: `const json = pm.response.json();`
  - Limpar variáveis sensíveis ao final (ex: `pm.environment.unset('temp')`

---

## 4. Exemplos de Teste Bem Estruturado

### Listar Usuários
```javascript
// Testa schema e quantidade
const json = pm.response.json();

pm.test('Schema básico: quantidade e usuarios[]', function () {
  pm.expect(json).to.have.property('quantidade');
  pm.expect(json).to.have.property('usuarios').that.is.an('array');
});

pm.test('quantidade é número >= 0', function () {
  pm.expect(json.quantidade).to.be.a('number').and.be.above(-1);
});

pm.test('Itens possuem campos obrigatórios', function () {
  json.usuarios.forEach((user) => {
    ['nome', 'email', 'password', '_id'].forEach((field) => {
      pm.expect(user).to.have.property(field);
    });
  });
});
```

### Excluir Recurso (Múltiplas Mensagens Válidas)
```javascript
const json = pm.response.json();

pm.test('Response contém message', function () {
  pm.expect(json).to.have.property('message');
});

pm.test('Mensagem de sucesso ou sem registros', function () {
  // Aceita tanto "Registro excluído" quanto "Nenhum registro excluído"
  pm.expect(json.message).to.match(/exclu[ií]do|nenhum/i);
});

pm.environment.unset('resourceId'); // Limpeza
```

---

## 5. Variáveis de Ambiente - Estratégia

### Dinâmicas (Geradas durante execução)
```
token           (obtido do login)
userId          (obtido da criação de usuário)
adminUserId     (obtido da criação de admin)
```

### Estáticas (Configuradas manualmente ou por CI)
```
baseUrl         (https://serverest.dev)
adminEmail      (admin@teste.com - preenchido no ambiente)
adminPassword   (Admin@12345)
```

### Limpeza
Sempre fazer `pm.environment.unset('tempVar')` ao final de testes que precisem de variáveis temporárias.

---

## 6. Rodando Localmente vs CI

### Local
```bash
npm run test:api
# Gera: allure-results/ e html-report/
```

### CI (Jenkins)
```bash
npm run test:api
# Newman roda com --delay-request 700 (veja package.json)
# Jenkins arquiva allure-results/ e html-report/
# Publisha Allure Report via plugin
```

---

## 7. Troubleshooting Comum

| Problema | Causa | Solução |
|----------|-------|---------|
| `Identifier 'json' has already been declared` | Dupla declaração de `const json` | Remover linhas duplicadas no script |
| Teste falha intermitentemente | Regex muito restritiva ou timing | Usar regex flexível, adicionar delays |
| Token expirado no CI | Token com timeout curto | Usar `--delay-request` maior ou renovar token dinamicamente |
| Variável não existe | Ordem de execução errada | Validar com `pm.test()` no pre-request |

---

## 8. Próximos Passos

- [ ] **Documentar cada endpoint** com exemplos de sucesso/erro
- [ ] **Criar ambientes separados** para Dev/Staging/Prod
- [ ] **Parametrizar queries** para testes parametrizados
- [ ] **Adicionar testes de segurança** (validar headers, SQL injection, etc.)
- [ ] **Setup CI webhook** para disparo automático em push

---

## Referências

- [Postman Learning Center](https://learning.postman.com/)
- [Newman CLI](https://github.com/postmanlabs/newman)
- [Allure Report](https://docs.qameta.io/allure/)
- [ServeRest API](https://serverest.dev/)
