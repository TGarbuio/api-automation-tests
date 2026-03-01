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
        sh 'rm -rf allure-results html-report'
        script {
          int status = sh(script: 'npm run test:api', returnStatus: true)
          if (status != 0) {
        currentBuild.result = 'UNSTABLE'
        echo "Newman failed (exit code ${status}). Marking build as UNSTABLE."
      }
    }
  }
        post {
          always {
            archiveArtifacts artifacts: 'allure-results/**,html-report/**', allowEmptyArchive: true
          }
        }
}
    }

    stage('Allure Report') {
       when {
        expression { fileExists('allure-results') }
        }
      steps {
      allure([
        includeProperties: false,
        jdk: '',
        results: [[path: 'allure-results']]
    ])
  }
}
  }
}