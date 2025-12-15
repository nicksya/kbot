pipeline {
    agent any
    environment {
        REPO = "https://github.com/nicksya/kbot"
        BRANCH = "main"
    }
    stages {
        stage("clone") {
            steps {
                echo "CLONE REPOSITORY"
                    git branch: "${BRANCH}", url: "${REPO}"
            }
        }
        stage("test") {
            steps {
                echo "TEST EXECUTION STARTED"
                sh 'make test'
            }
        }
        stage("build") {
            steps {
                echo "BUILD EXECUTION STARTED"
                sh 'make build TARGETOS=$OS TARGETARCH=$ARCH'
            }
        }
        stage("image") {
            steps {
                echo "IMAGE PREPARATION STARTED"
                sh 'make image TARGETOS=$OS TARGETARCH=$ARCH'
            }
        }
        stage("push") {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub') {
                        sh 'make push TARGETOS=$OS TARGETARCH=$ARCH'
                    }
                }
            }
        }
    }
    
    parameters {
        choice(
            name: 'OS',
            choices: ['linux', 'darwin', 'windows'],
            description: 'Target operating system'
        )
        choice(
            name: 'ARCH',
            choices: ['amd64', 'arm64'],
            description: 'Target architecture'
        )
        booleanParam(
            name: 'SKIP_TESTS',
            defaultValue: false,
            description: 'Skip running tests'
        )
        booleanParam(
            name: 'SKIP_LINT',
            defaultValue: false,
            description: 'Skip running linter'
        )
    }
}