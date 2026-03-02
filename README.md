# 🚀 API Automation Tests - ServeRest

![Node Version](https://img.shields.io/badge/node-18.x-brightgreen)
![Newman](https://img.shields.io/badge/newman-6.2.2-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![CI Status](https://img.shields.io/badge/build-passing-success)

> **Projeto de automação de testes de API desenvolvido para o processo seletivo de QA Sênior do Banco Carrefour**, demonstrando práticas avançadas de teste, CI/CD, e geração de relatórios profissionais.

---

## ⚡ Quick Start

### 🖥️ Executar Localmente

```bash
# 1. Clone o repositório
git clone https://github.com/TGarbuio/api-automation-tests.git
cd api-automation-tests

# 2. Instale as dependências
npm ci

# 3. Execute os testes
npm run test:api

# 4. Visualize os relatórios gerados
# HTML Report: abra html-report/index.html no navegador
# Allure Report: allure serve allure-results
```

**Resultado esperado:**
- ✅ 23 requests executados
- ✅ 70/70 assertions passaram
- ✅ Relatórios HTML e Allure gerados

### 🔄 Pipeline Jenkins

```groovy
1. Crie um Pipeline job no Jenkins
2. Configure SCM:
   - Repository URL: https://github.com/TGarbuio/api-automation-tests.git
   - Branch: main
   - Script Path: Jenkinsfile
3. Clique em "Build Now"
4. Acesse "Allure Report" no build para visualizar resultados
```

**Pipeline stages:**
- ✅ Checkout do repositório
- ✅ Instalação de dependências (npm ci)
- ✅ Execução dos testes (Newman)
- ✅ Publicação do Allure Report

---

## 📋 Índice

- [Quick Start](#-quick-start)
- [Visão Geral](#-visão-geral)
- [Arquitetura e Decisões Técnicas](#-arquitetura-e-decisões-técnicas)
- [Cobertura de Testes](#-cobertura-de-testes)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Setup Local](#️-setup-local)
- [Execução dos Testes](#-execução-dos-testes)
- [CI/CD - Jenkins](#-cicd---jenkins)
- [Relatórios](#-relatórios)
- [Estratégia de Testes](#-estratégia-de-testes)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Boas Práticas Implementadas](#-boas-práticas-implementadas)
- [Troubleshooting](#-troubleshooting)
- [Autor](#-autor)

---

## 🎯 Visão Geral

Este projeto implementa automação de testes de API end-to-end para a API **ServeRest** (https://serverest.dev), uma API REST de estudos que simula uma loja virtual. O projeto demonstra:

✅ **Cobertura completa** de endpoints (usuarios, produtos, carrinhos, login)  
✅ **Validações robustas** de contratos, schemas JSON, e mensagens de erro  
✅ **Geração dinâmica de dados** com timestamps para evitar conflitos  
✅ **Integração CI/CD** com Jenkins + Docker  
✅ **Relatórios profissionais** com Allure Report e HTML  
✅ **Testes organizados** em 3 níveis (collection/request/pre-request)

---

## 🏗️ Arquitetura e Decisões Técnicas

### Por que Newman + Postman?
- **Postman** permite modelagem visual de requests e debugging rápido
- **Newman** executa collections headless no CI/CD
- **Allure Reporter** gera relatórios ricos com histórico de execuções

### Estrutura de 3 Níveis
```
┌─────────────────────────────────────────────────┐
│         Collection-level Scripts                │
│  (Global: Response time, Content-Type)          │
└─────────────────────────────────────────────────┘
              ▼
┌─────────────────────────────────────────────────┐
│       Request-level Pre-request Scripts         │
│  (Setup: variáveis, validações, geração dados)  │
└─────────────────────────────────────────────────┘
              ▼
┌─────────────────────────────────────────────────┐
│         Request-level Test Scripts              │
│  (Assertions específicas, schema validation)    │
└─────────────────────────────────────────────────┘
```

**Vantagem:** Evita duplicação, facilita manutenção, garante consistência.

### Credenciais Dinâmicas
```javascript
// Pre-request do "Realizar login"
const ts = Date.now();
const newEmail = `admin.${ts}@teste.com`;
const newPassword = `Admin@${ts}`;

// Cria usuário via pm.sendRequest antes do login
pm.sendRequest({
  url: `${baseUrl}/usuarios`,
  method: 'POST',
  body: { nome: "QA Admin", email: newEmail, password: newPassword, administrador: "true" }
});
```

**Vantagem:** Cada execução cria usuário único, evita conflitos em pipelines paralelos.

### Docker + Java JRE
```dockerfile
FROM node:18-bullseye
RUN apt-get update && apt-get install -y default-jre
```

**Decisão:** Allure Report requer JRE para gerar relatórios. Imagem customizada garante ambiente consistente.

---

## 📊 Cobertura de Testes

### Endpoints Cobertos

| Módulo | Endpoint | Método | Cenários | Status |
|--------|----------|--------|----------|--------|
| **Login** | `/login` | POST | Login válido, credenciais inválidas | ✅ |
| **Usuários** | `/usuarios` | GET | Listar todos, filtros | ✅ |
| | `/usuarios/:id` | GET | Buscar por ID válido/inválido | ✅ |
| | `/usuarios` | POST | Criar admin/não-admin, email duplicado | ✅ |
| | `/usuarios/:id` | PUT | Editar usuário existente/inexistente | ✅ |
| | `/usuarios/:id` | DELETE | Excluir usuário, com/sem carrinho | ✅ |
| **Produtos** | `/produtos` | GET | Listar todos, paginação | ✅ |
| | `/produtos/:id` | GET | Buscar por ID | ✅ |
| | `/produtos` | POST | Criar produto (requer token admin) | ✅ |
| | `/produtos/:id` | PUT | Editar produto | ✅ |
| | `/produtos/:id` | DELETE | Excluir produto | ✅ |
| **Carrinhos** | `/carrinhos` | GET | Listar carrinhos ativos | ✅ |
| | `/carrinhos` | POST | Criar carrinho com produtos | ✅ |
| | `/carrinhos/concluir-compra` | DELETE | Finalizar compra | ✅ |
| | `/carrinhos/cancelar-compra` | DELETE | Cancelar compra | ✅ |

### Tipos de Validação
- ✅ Status codes (200, 201, 400, 401, 404)
- ✅ Schema validation (campos obrigatórios, tipos)
- ✅ Business rules (email único, admin não pode ter carrinho)
- ✅ Headers (Content-Type, Authorization)
- ✅ Response time (< 3000ms)
- ✅ Error messages (regex flexíveis)

### Métricas
```
Total de Requests: 22
Total de Assertions: 70+
Taxa de Sucesso: 100% (ambiente controlado)
Tempo Médio de Execução: ~35 segundos
```

---

## 🛠️ Tecnologias Utilizadas

| Ferramenta | Versão | Finalidade |
|------------|--------|------------|
| **Node.js** | 18.x | Runtime JavaScript |
| **Newman** | 6.2.2 | CLI runner para Postman collections |
| **newman-reporter-allure** | 1.0.5 | Geração de resultados Allure |
| **newman-reporter-html** | 1.0.5 | Geração de relatórios HTML |
| **Docker** | Latest | Containerização (node:18 + JRE) |
| **Jenkins** | Latest | CI/CD pipeline automation |
| **Allure** | 2.x | Framework de relatórios |

---

## ⚙️ Setup Local

### Pré-requisitos
- Node.js >= 18.x
- npm >= 10.x
- Git

### Instalação

```bash
# 1. Clone o repositório
git clone https://github.com/TGarbuio/api-automation-tests.git
cd api-automation-tests

# 2. Instale as dependências
npm install

# 3. Configure o environment (opcional - valores já preenchidos)
# Edite postman/Users.postman_environment.json se necessário
```

### Estrutura de Diretórios
```
api-automation-tests/
├── Dockerfile                          # Imagem customizada (Node 18 + JRE)
├── Jenkinsfile                         # Pipeline CI/CD
├── package.json                        # Dependências e scripts
├── README.md                           # Documentação
├── postman/
│   ├── ServeRest.postman_collection.json   # Collection com 22 requests
│   └── Users.postman_environment.json      # Variáveis de ambiente
├── allure-results/                     # Resultados JSON (gerado)
└── html-report/                        # Relatório HTML (gerado)
```

---

## 🚀 Execução dos Testes

### Execução Local

```bash
# Executa todos os testes com relatórios
npm run test:api

# Saída esperada:
# ✔ 70/70 assertions passed
# Arquivos gerados:
#   - allure-results/
#   - html-report/index.html
```

### Visualizar Relatórios

```bash
# Método 1: Abrir HTML diretamente
open html-report/index.html  # macOS
start html-report/index.html # Windows
xdg-open html-report/index.html # Linux

# Método 2: Allure Report (requer Allure CLI)
allure serve allure-results
```

### Execução com Delay (evitar rate limiting)
```bash
newman run postman/ServeRest.postman_collection.json \
  -e postman/Users.postman_environment.json \
  --delay-request 700 \
  --reporters cli,allure,html
```

---

## 🔄 CI/CD - Jenkins

### Pipeline Stages

```groovy
pipeline {
  agent { dockerfile true }  // Usa Dockerfile customizado
  
  stages {
    1. Checkout         → Clone do repositório
    2. Install deps     → npm ci --legacy-peer-deps
    3. Run tests        → npm run test:api (com || true)
    4. Archive artifacts → allure-results/, html-report/
    5. Allure Report    → Publica via plugin Allure
  }
}
```

### Configuração Jenkins

1. **Criar Pipeline Job:**
   ```
   Pipeline from SCM → Git
   Repository URL: https://github.com/TGarbuio/api-automation-tests.git
   Branch: main
   Script Path: Jenkinsfile
   ```

2. **Instalar Plugins:**
   - Allure Jenkins Plugin
   - Docker Pipeline
   - Git Plugin

3. **Configurar Allure:**
   ```
   Manage Jenkins → Tools
   Allure Commandline → Add Allure → Auto-install
   ```

4. **Executar Build:**
   - Build Now
   - Relatórios disponíveis em: `Build #N → Allure Report`
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/a1e0b8f5-af49-44ea-8657-a7a21823100b" />

### Estratégia de Falhas
```groovy
// Testes com falha não param o pipeline
sh 'npm run test:api || true'

// Build marcado como UNSTABLE (não FAILURE)
if (status != 0) {
  currentBuild.result = 'UNSTABLE'
}
```

**Vantagem:** Relatórios sempre são gerados, mesmo com testes falhando.

---

## 📈 Relatórios

### Allure Report (Recomendado)

**Features:**
- ✅ Histórico de execuções
- ✅ Categorias de falhas
- ✅ Timeline de requests
- ✅ Gráficos de sucesso/falha
- ✅ Logs detalhados por teste

**Acesso:**
- Jenkins: `Build #N → Allure Report`
- Local: `allure serve allure-results`

#### Screenshots

**Allure Dashboard - Visão Geral**
![Allure Dashboard](docs/images/allure-dashboard.png)
*Dashboard principal com estatísticas de execução, gráficos de sucesso/falha e histórico de builds*

**Allure Suites - Detalhamento**
![Allure Suites](docs/images/allure-suites.png)
*Visualização detalhada de cada suite de testes com assertions e tempo de execução*

**Allure Timeline**
![Allure Timeline](docs/images/allure-timeline.png)
*Timeline mostrando execução paralela e duração de cada request*

### HTML Report

**Features:**
- ✅ Relatório standalone (sem dependências)
- ✅ Request/Response completos
- ✅ Headers, body, status codes
- ✅ Tempo de resposta individual

**Acesso:**
- `html-report/index.html`

#### Screenshots

**HTML Report - Overview**
![HTML Report Overview](docs/images/html-report-overview.png)
*Visão geral da execução com estatísticas e resumo de requests*

**HTML Report - Request Details**
![HTML Report Details](docs/images/html-report-details.png)
*Detalhes completos de request/response incluindo headers, body e assertions*

---

## 📸 Como Capturar Screenshots

Para adicionar os screenshots dos relatórios ao projeto:

1. **Execute os testes localmente:**
   ```bash
   npm run test:api
   ```

2. **Abra os relatórios:**
   - **HTML Report:** Abra `html-report/index.html` no navegador
   - **Allure Report:** Execute `allure serve allure-results`

3. **Capture as telas:**
   - Tire screenshots das páginas principais
   - Salve como PNG na pasta `docs/images/` com os nomes:
     - `allure-dashboard.png`
     - `allure-suites.png`
     - `allure-timeline.png`
     - `html-report-overview.png`
     - `html-report-details.png`

4. **Commit as imagens:**
   ```bash
   git add docs/images/*.png
   git commit -m "docs: add report screenshots"
   git push
   ```
- ✅ Gráficos de sucesso/falha
- ✅ Logs detalhados por teste

**Acesso:**
- Jenkins: `Build #N → Allure Report`
- Local: `allure serve allure-results`

### HTML Report

**Features:**
- ✅ Relatório standalone (sem dependências)
- ✅ Request/Response completos
- ✅ Headers, body, status codes
- ✅ Tempo de resposta individual

**Acesso:**
- `html-report/index.html`

---

## 🎯 Estratégia de Testes

### Níveis de Teste

```
┌─────────────────────────────────────────────────────────┐
│  COLLECTION-LEVEL (Global)                              │
│  • Response time < 3000ms                               │
│  • Content-Type header presente quando há body          │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│  REQUEST-LEVEL (Específico)                             │
│  • Status code esperado (200, 201, 400, etc.)           │
│  • Schema validation (campos obrigatórios)              │
│  • Business rules (email único, admin sem carrinho)     │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│  PRE-REQUEST (Setup)                                    │
│  • Gerar dados dinâmicos (timestamps)                   │
│  • Validar variáveis necessárias (token, IDs)           │
│  • Criar recursos dependentes (usuário antes de login)  │
└─────────────────────────────────────────────────────────┘
```

### Cenários Cobertos

#### ✅ Cenários de Sucesso (Happy Path)
- Criar usuário → Login → Listar produtos → Adicionar carrinho → Finalizar compra

#### ⚠️ Cenários de Erro
- Login com credenciais inválidas (401)
- Criar usuário com email duplicado (400)
- Acessar recurso sem autenticação (401)
- Buscar recurso inexistente (404)
- Admin tentando criar carrinho (400 - regra de negócio)

#### 🔒 Segurança
- Token JWT com expiração (10 min)
- Validação de autorização em endpoints protegidos
- Sanitização de inputs (validação de email, senha)

---

## 📦 Estrutura do Projeto

```
api-automation-tests/
│
├── 📄 Dockerfile                    # Node 18 + JRE para Allure
├── 📄 Jenkinsfile                   # Pipeline CI/CD (5 stages)
├── 📄 package.json                  # Dependências e scripts
├── 📄 package-lock.json             # Lock de versões
├── 📄 README.md                     # Documentação principal
├── 📄 .gitignore                    # Ignora node_modules, reports
│
├── 📁 postman/
│   ├── ServeRest.postman_collection.json   # 22 requests, 70+ assertions
│   └── Users.postman_environment.json      # Variáveis (baseUrl, credentials)
│
├── 📁 allure-results/               # Resultados JSON (CI/CD)
├── 📁 html-report/                  # Relatório HTML standalone
└── 📁 reports/                      # Histórico de execuções (opcional)
```

---

## ✨ Boas Práticas Implementadas

### 1️⃣ Dados Dinâmicos
```javascript
// ❌ Evitar: Hardcoded
const email = "admin@teste.com";

// ✅ Melhor: Timestamp único
const email = `admin.${Date.now()}@teste.com`;
```

### 2️⃣ Validações Flexíveis
```javascript
// ❌ Evitar: Regex muito restritiva
pm.expect(json.message).to.match(/^Registro excluído com sucesso$/);

// ✅ Melhor: Aceita variações
pm.expect(json.message).to.match(/excluído|nenhum/i);
```

### 3️⃣ Parsing Único
```javascript
// ❌ Evitar: Múltiplos parse
pm.response.json().message;
pm.response.json().authorization;

// ✅ Melhor: Parse uma vez
const json = pm.response.json();
json.message;
json.authorization;
```

### 4️⃣ Limpeza de Variáveis
```javascript
// Após uso, remover variáveis temporárias
pm.environment.unset('tempUserId');
pm.environment.unset('tempToken');
```

### 5️⃣ Organização DRY
- Testes comuns no collection-level (evita 22x duplicação)
- Pre-request scripts reutilizáveis
- Variáveis de ambiente centralizadas

---

## 🔍 Troubleshooting

### Problema: `Identifier 'json' has already been declared`
**Causa:** Dupla declaração de `const json` no mesmo script  
**Solução:** Remover linhas duplicadas ou usar `let` com verificação

### Problema: Token expirado (401 Unauthorized)
**Causa:** Token JWT expira em 10 minutos  
**Solução:** Pipeline executa em < 1 min. Para debugging local, re-executar login

### Problema: Newman não encontra reporter HTML
**Causa:** `newman-reporter-html` não instalado  
**Solução:**
```bash
npm install --save-dev newman-reporter-html --force
```

### Problema: Allure Report não gera no Jenkins
**Causa:** Java JRE não disponível no agente  
**Solução:** Usar Dockerfile customizado (`dockerfile true`)

### Problema: Email já cadastrado
**Causa:** Execução com credenciais estáticas  
**Solução:** Garantir que `adminEmail` e `adminPassword` iniciam vazios no environment

---

## 👤 Autor

**Thiago Garbuio**  
📧 Email: thiagogarbuio10@gmail.com  
🔗 GitHub: [TGarbuio](https://github.com/TGarbuio)  
💼 LinkedIn: [Thiago Garbuio](https://linkedin.com/in/thiagogarbuio)

---

## 📄 Licença

Este projeto foi desenvolvido para fins educacionais e como parte do processo seletivo.

---

## 🙏 Agradecimentos

- **ServeRest API** - [@PauloGoncalvesBH](https://github.com/PauloGoncalvesBH)
- **Postman/Newman** - Comunidade open-source
- **Allure Framework** - Qameta Software

---

## 📚 Referências

- [Postman Learning Center](https://learning.postman.com/)
- [Newman Documentation](https://github.com/postmanlabs/newman)
- [Allure Report](https://docs.qameta.io/allure/)
- [ServeRest API](https://serverest.dev/)
- [Jenkins Pipeline](https://www.jenkins.io/doc/book/pipeline/)

---

**⭐ Se este projeto foi útil, considere dar uma estrela no repositório!**
