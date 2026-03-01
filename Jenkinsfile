pipeline {
  agent {
    docker {
      image 'node:18'
    }
  }

  options {
    timestamps()
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install dependencies') {
      steps {
        sh 'node --version'
        sh 'npm --version'
        // Recomendado para CI (usa package-lock.json)
        sh 'npm ci --legacy-peer-deps'
      }
    }

    stage('Run API tests (Newman)') {
      steps {
        // limpar resultados anteriores (se existirem)
        sh 'rm -rf allure-results html-report'

        // roda a collection e gera allure-results/ e html-report/
        sh 'npm run test:api'
      }
      post {
        always {
          archiveArtifacts artifacts: 'allure-results/**,html-report/**', allowEmptyArchive: true
        }
      }
    }

    stage('Allure Report') {
      steps {
        // Publica o relatório no Jenkins (requer plugin Allure + tool configurada)
        allure([
          includeProperties: false,
          jdk: '',
          results: [[path: 'allure-results']]
        ])
      }
    }
  }
}