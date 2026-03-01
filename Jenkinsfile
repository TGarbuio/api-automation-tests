pipeline {
  agent any

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
        bat 'node --version'
        bat 'npm --version'
        // Recomendado para CI (usa package-lock.json)
        bat 'npm ci'
      }
    }

    stage('Run API tests (Newman)') {
      steps {
        // limpar resultados anteriores (se existirem)
        bat 'if exist allure-results rmdir /s /q allure-results'
        bat 'if exist html-report rmdir /s /q html-report'

        // roda a collection e gera allure-results/ e html-report/
        bat 'npm run test:api'
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