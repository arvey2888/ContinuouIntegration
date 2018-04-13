pipeline {
  agent any
  stages {
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
  }
}