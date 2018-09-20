#!/usr/bin/env groovy
node{
    stage('test stage')
    {
          echo 'Hello, stage1'
          echo "Hello ${params.PERSON}"
          echo "Hello ${env.PERSON}"
          whichMaven(maven:"LOCAL_MAVEN"){
            sh '''
            which java
            which mvn
            which gradle
            '''
            echo "AAAAAA params.CHOICE"
            def input = params.YESORNO
            if (input)
            {
              echo "you input is ${input},to do sth"
            }
            else
            {
              echo "you input is ${input},nothing to do"
            }
         }
    }
}

