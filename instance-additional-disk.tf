pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')     // Jenkins credential ID
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY') // Jenkins credential ID
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/Himani19111/Instance-creation-Additional-Disk.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Format Check') {
            steps {
                sh 'terraform fmt -check'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Do you want to apply this plan?'
                sh 'terraform apply -input=false tfplan'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
