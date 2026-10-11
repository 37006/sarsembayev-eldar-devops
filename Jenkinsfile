pipeline {
    agent any
    options {
        skipDefaultCheckout(true)
        disableConcurrentBuilds()
        timeout(time: 15, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }
    environment {
        STUDENT_NAME = 'Eldar'
        STUDENT_SURNAME = 'Sarsembayev'
        STUDENT_GROUP = 'IT2-2301'
        STUDENT_ID = '37006'
        IMAGE_NAME = 'sarsembayev-eldar-devops'
        CONTAINER_NAME = 'sarsembayev-eldar-container'
        HOST_PORT = '8082'
        PYTHONDONTWRITEBYTECODE = '1'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh '''
                    set -eu
                    printf 'Student: %s %s\n' "$STUDENT_NAME" "$STUDENT_SURNAME"
                    printf 'Group: %s\nStudent ID: %s\n' "$STUDENT_GROUP" "$STUDENT_ID"
                    git rev-parse HEAD
                    git log -1 --format='%h %s'
                    test "$(uname -s)" = Linux
                    command -v python3
                    command -v docker
                    docker info --format 'Docker server: {{.ServerVersion}}'
                '''
            }
        }
        stage('Build') {
            steps {
                sh 'python3 -m compileall -q app tests'
            }
        }
        stage('Test') {
            steps {
                sh 'python3 -m unittest discover -s tests -v'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t "$IMAGE_NAME:build-$BUILD_NUMBER" -t "$IMAGE_NAME:latest" .'
            }
        }
        stage('Docker Run') {
            steps {
                sh 'bash scripts/run_container.sh "$IMAGE_NAME:build-$BUILD_NUMBER"'
            }
        }
    }
    post {
        success {
            echo 'All five stages and container health verification passed.'
            sh '''
                git rev-parse HEAD
                docker images "$IMAGE_NAME"
                docker ps --filter "name=^/$CONTAINER_NAME$"
                docker logs "$CONTAINER_NAME"
            '''
        }
        failure {
            echo 'Pipeline failed. Inspect the first failing stage in Console Output.'
            sh 'docker logs "$CONTAINER_NAME" 2>/dev/null || true'
        }
    }
}
