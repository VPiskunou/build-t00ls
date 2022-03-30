job('Day-6/MNTLAB-vpiskunou-main-build-job') {
  description 'The Main job'

  parameters {
    gitParam('BRANCH_NAME') {
      description 'Homework 6'
      type 'BRANCH'
      defaultValue 'origin/main'
    }
    activeChoiceReactiveParam('Job_name') {
           description('Allows job choose from multiple choices')
           choiceType('CHECKBOX')
           groovyScript {
               script('return ["Day-6/MNTLAB-vpiskunou-child1-build-job", "Day-6/MNTLAB-vpiskunou-child2-build-job", "Day-6/MNTLAB-vpiskunou-child3-build-job", "Day-6/MNTLAB-vpiskunou-child4-build-job"]')
           }
    }
  }

  scm {
    git {
      remote {
        url 'https://github.com/VPiskunou/build-t00ls'
      }
      branch '$BRANCH_NAME'
    }
  }
  steps {
       downstreamParameterized {
               trigger('$Job_name') {
                 block {
                    buildStepFailure('FAILURE')
                    failure('FAILURE')
                    unstable('UNSTABLE')
                 }
                 parameters {
                     currentBuild()
                 }
           }
       }
   }
}
def JOBS = ["Day-6/MNTLAB-vpiskunou-child1-build-job", "Day-6/MNTLAB-vpiskunou-child2-build-job", "Day-6/MNTLAB-vpiskunou-child3-build-job", "Day-6/MNTLAB-vpiskunou-child4-build-job"]
for(job in JOBS) {


mavenJob(job) {
  description 'Child work'
  parameters {
    gitParam('BRANCH_NAME') {
      description 'Homework 6 child'
      type 'BRANCH'
    }
    activeChoiceReactiveParam('Job_name') {
           description('Allows job choose from multiple choices')
           choiceType('CHECKBOX')
           groovyScript {
               script('return ["Day-6/MNTLAB-vpiskunou-child1-build-job", "Day-6/MNTLAB-vpiskunou-child2-build-job", "Day-6/MNTLAB-vpiskunou-child3-build-job", "Day-6/MNTLAB-vpiskunou-child4-build-job"]')
           }
    }
  }

  scm {
    git {
      remote {
        url 'https://github.com/VPiskunou/build-t00ls'
      }
      branch '$BRANCH_NAME'
    }
  }

  triggers {
    scm 'H/10 * * * *'
  }

  rootPOM 'home-task/pom.xml'
  goals 'clean install'
  postBuildSteps {
        shell('nohup java -jar home-task/target/task-jenkins-3-0.1.jar com.test >> home-task/target/output.log')
        shell('tar -cvf "$(echo $BRANCH_NAME | cut -d "/" -f 2)_dsl_script.tar.gz" home-task/target/*.jar home-task/target/output.log')
    }

  publishers {
        archiveArtifacts('*.tar.gz')
    }
}
}