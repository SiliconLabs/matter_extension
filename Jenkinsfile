#!groovy
@Library('gsdk-shared-lib@master')
import groovy.json.JsonSlurper


def pipeline()
{
    stage('Checkout matter_private and load Jenkinsfile')
    {
        node('buildNFS')
        {
            // ************************************************************************************
            //  Clone Matter repo, checkout corresponding branch, checkout matter_private submodule
            // ************************************************************************************           
            def scmVars = checkout scm: [$class              : 'GitSCM',
                            branches                         : scm.branches,
                            browser                          : [$class: 'Stash', repoUrl: 'https://stash.silabs.com/projects/WMN_TOOLS/repos/matter_extension/'],
                            doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
                            extensions                       : [[$class: 'ScmName', name: 'matter_extension']],
                            userRemoteConfigs                : scm.userRemoteConfigs]   
        
        
        def previousCommit = scmVars.GIT_PREVIOUS_COMMIT
        def currentCommit = scmVars.GIT_COMMIT

        echo "Previous commit: ${previousCommit}"
        echo "Current Commit: ${currentCommit}"

        // Only check for new commit if build is triggered by pollSCM
        if (currentBuild.getBuildCauses('hudson.triggers.SCMTrigger$SCMTriggerCause').size() > 0) {
            if (previousCommit == currentCommit) {
                echo "No changes in matter_extension. Exiting."
                isNewCommitDetected = false
                return
            } else {
                echo "Changes detected in matter_extension. Proceeding."
                isNewCommitDetected = true
            }
        }
           
            sh """
                git submodule update --init  --checkout third_party/matter_private
            """
            // Load metadata from the submodule
            pipelineFunctions = load 'third_party/matter_private/jenkins/Jenkinsfile'
        
            // export the NFS overlay
            sh 'sudo exportfs -af'
        } 
        pipelineFunctions.runScript()
    }
}

def postFailure(e)
{
    currentBuild.result = 'FAILURE'
}

def postAlways()
{
    stage('Cleanup Overlays')
    {
        advanceStageMarker()
        node('buildNFS')
        {
            // clean up the things that have been pushed to the overlay
            sh '/srv/jenkins/createSuperOverlay.sh '+
               'removebuildoverlay '+
               buildOverlayDir
            dir('/srv/jenkins/overlays/') {
                sh 'rm -rf ' + advanceStageMarker.nfsOverlayWorkspaceRoot.replace('/mnt/nfs', '/srv/jenkins')
            }
        }
    }
}

// TODO lock the repo resource?
try {
    pipeline()
} catch (e) {
    postFailure(e)
    throw e
} finally {
    postAlways()
}