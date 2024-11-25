pipeline {
    agent none
    parameters {
        string description: 'Please fill your branch target.', name: 'BRANCH_NAME', trim: true
    }
    stages {
        stage('Verify Branch Name') {
            steps {
                script {
                    if (env.WEBHOOK_BRANCH) { 
                        def webhookBranch = env.WEBHOOK_BRANCH.replaceFirst("refs/heads/", "")
                        echo "Job triggered by webhook. Detected branch from webhook: ${webhookBranch}"
                        env.BRANCH_NAME = webhookBranch
                    } else {
                        echo "No WEBHOOK_BRANCH detected. Using input parameter BRANCH_NAME: ${params.BRANCH_NAME}"
                        env.BRANCH_NAME = params.BRANCH_NAME
                    }
                }
            }
        }
        stage('Parallel Execution') {
            parallel {
                stage('Node Server 1') {
                    agent {
                        label 'node-server-1'
                    }
                    stages {
                        stage('CLONE REPOSITORY') {
                            steps {
                                script {
                                    echo 'Cloning repository on Node Server 1...'
                                    sh 'chmod -R 755 $WORKSPACE'
                                    sh './00.clone_repository.sh'
                                }
                            }
                        }
                        stage('TEST THE LOCAL APP') {
                            steps {
                                script {
                                    echo 'Testing app on Node Server 1...'
                                    sh './01.testing_local_app.sh'
                                }
                            }
                        }
                        stage('BUILD AND RUN DOCKER IMAGE') {
                            steps {
                                script {
                                    echo 'Build and Run Docker image on Node Server 1...'
                                    sh './02.docker_installation.sh'
                                    sh './03.docker_run.sh'
                                }
                            }
                        }
                    }
                }
                stage('Node Server 2') {
                    agent {
                        label 'node-server-2'
                    }
                    stages {
                        stage('CLONE REPOSITORY') {
                            steps {
                                script {
                                    echo 'Cloning repository on Node Server 2...'
                                    sh 'chmod -R 755 $WORKSPACE'
                                    sh './00.clone_repository.sh'
                                }
                            }
                        }
                        stage('TEST THE LOCAL APP') {
                            steps {
                                script {
                                    echo 'Testing app on Node Server 2...'
                                    sh './01.testing_local_app.sh'
                                }
                            }
                        }
                        stage('BUILD AND RUN DOCKER IMAGE') {
                            steps {
                                script {
                                    echo 'Build and Run Docker image on Node Server 2...'
                                    sh './02.docker_installation.sh'
                                    sh './03.docker_run.sh'
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    post {
        success {
            script {
                echo "The servers are successfully running and accessible via the Load Balancer: http://ntx-devops-test-alb-1605014626.us-east-2.elb.amazonaws.com/"
            }
        }
    }
}
