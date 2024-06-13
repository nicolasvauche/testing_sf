pipeline {
    agent {
        docker {
            image 'php:8.2'
            args '-u root'
        }
    }
    environment {
        COMPOSER_CACHE_DIR = '/var/jenkins_home/composer_cache'
        DB_HOST = '127.0.0.1'
        DB_PORT = '3306'
        DB_NAME = 'sf_testing'
        DB_USER = 'root'
        DB_PASSWORD = 'root'
        DB_SERVER_VERSION = '11.3.2-MariaDB'
        DB_CHARSET = 'utf8mb4'
    }
    stages {
        stage('Install Dependencies') {
            steps {
                sh 'apt-get update && apt-get install -y git unzip'
                sh 'docker-php-ext-install pdo pdo_mysql'
                sh 'curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer'
                sh 'composer install --prefer-dist --no-interaction'
            }
        }
        stage('Create .env.test.local') {
            steps {
                script {
                    def dbUrl = "mysql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}?serverVersion=${DB_SERVER_VERSION}&charset=${DB_CHARSET}"
                    writeFile file: '.env.test.local', text: "DATABASE_URL=\"${dbUrl}\"\n"
                }
            }
        }
        stage('Setup Database') {
            steps {
                script {
                    // Exécuter les commandes SQL nécessaires pour configurer la base de données
                    sh 'mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"'
                }
            }
        }
        stage('Run Linter') {
            steps {
                sh './vendor/bin/php-cs-fixer fix --dry-run --diff'
            }
        }
        stage('Run Tests') {
            steps {
                sh 'APP_ENV=test ./vendor/bin/phpunit'
            }
        }
    }
    post {
        always {
            junit 'tests/logs/junit.xml'
            archiveArtifacts artifacts: '**/build/logs/*.xml', allowEmptyArchive: true
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
