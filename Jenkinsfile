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

