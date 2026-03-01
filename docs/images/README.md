# 📸 Screenshots dos Relatórios

Esta pasta contém os screenshots dos relatórios Allure e HTML.

## Como Gerar os Screenshots

### 1. Execute os testes
```bash
npm run test:api
```

### 2. Gere os relatórios

**Para Allure Report:**
```bash
allure serve allure-results
```

**Para HTML Report:**
- Abra `html-report/index.html` no navegador

### 3. Capture as seguintes telas

#### Allure Report (3 screenshots)

1. **allure-dashboard.png**
   - Página: Dashboard principal (Overview)
   - Capturar: Estatísticas gerais, gráfico de pizza, histórico de execuções

2. **allure-suites.png**
   - Página: Suites (menu lateral)
   - Capturar: Lista de suites expandida com requests e assertions

3. **allure-timeline.png**
   - Página: Timeline (menu lateral)
   - Capturar: Linha do tempo com execução de todos os requests

#### HTML Report (2 screenshots)

4. **html-report-overview.png**
   - Página: Primeira página do html-report/index.html
   - Capturar: Estatísticas, resumo da execução, lista de requests

5. **html-report-details.png**
   - Página: Expandir um request no HTML Report
   - Capturar: Detalhes completos (headers, body, response, assertions)

### 4. Salve as imagens aqui

Coloque os arquivos PNG nesta pasta com os nomes exatos acima.

### 5. Commit

```bash
git add docs/images/*.png
git commit -m "docs: add report screenshots"
git push
```

---

**Nota:** As imagens já estão referenciadas no README.md. Após adicionar os screenshots aqui, eles aparecerão automaticamente na documentação.
