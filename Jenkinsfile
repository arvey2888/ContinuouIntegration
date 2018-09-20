#!/usr/bin/env groovy
pipeline{
    agent none
    options{
        disableConcurrentBuilds()
        skipDefaultCheckout()
        timeout(time: 1, unit: 'HOURS')
        timestamps()
    }
    parameters{
        string(name: 'PERSON', defaultValue: 'among中文', description: '请输入中文')
        booleanParam(name: 'YESORNO', defaultValue: true, description: '是否发布')
        choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')
    }
    stages{
    stage('test stage')
    {
      steps
      {
          echo 'Hello, stage1'
          echo "Hello ${params.PERSON}"
          echo "Hello ${env.PERSON}"
      	  script
          {
            pwd
            which java
            which mvn
            which gradle
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
  }
}

