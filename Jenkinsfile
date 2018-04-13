pipeline {
  agent any
  stages {
    stage('Phase1') {
      parallel {
        stage('Phase1') {
          environment {
            JENKINS_createTag = 'Yes'
          }
          steps {
            sh '''#! /bin/bash
ls'''
            sh '''#! /bin/bash
ls -la'''
          }
        }
        stage('Phase1-2') {
          steps {
            echo 'Done'
          }
        }
        stage('Phase1-3') {
          steps {
            sh 'echo -e "Just Try"'
          }
        }
      }
    }
    stage('Phase2') {
      steps {
        archiveArtifacts '*'
      }
    }
  }
}