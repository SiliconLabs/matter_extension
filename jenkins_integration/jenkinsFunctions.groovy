def upload_artifacts(sqa=false, commit_sha="null", workflow_id="null", run_number="null") {
    withCredentials([
    usernamePassword(credentialsId: 'svc_gsdk', passwordVariable: 'SL_PASSWORD', usernameVariable: 'SL_USERNAME'),
    usernamePassword(credentialsId: 'Matter-Extension-GitHub', usernameVariable: 'GITHUB_APP', passwordVariable: 'GITHUB_ACCESS_TOKEN')
    ])
    {
        def output = sh(script: "python3 -u jenkins_integration/artifacts/upload_artifacts.py --branch_name ${env.BRANCH_NAME} --build_number ${env.BUILD_NUMBER} --sqa ${sqa} --commit_sha ${commit_sha} --workflow_id ${workflow_id} --run_number ${run_number}", returnStdout: true).trim()
        echo "Output from upload_artifacts.py: ${output}"
        if(!sqa){
            result = parse_upload_artifacts_output(output)
            return [commit_sha: result.commit_sha, run_number: result.run_number, workflow_id: result.workflow_id, bypass_results: result.bypass_send_results_gh, pr_number: result.pr_number]
        }
    }
}

def parse_upload_artifacts_output(output) {
        def sha_matcher = output =~ /Commit SHA - (\w+)/
        def commit_sha = sha_matcher ? sha_matcher[0][1] : null

        def run_number_matcher = output =~ /Workflow run number - (\d+)/
        def run_number = run_number_matcher ? run_number_matcher[0][1] : null

        def workflow_id_matcher = output =~ /Workflow ID - (\d+)/
        def workflow_id = workflow_id_matcher ? workflow_id_matcher[0][1] : null

        def bypass_matcher = output =~ /Bypass sending test results to GitHub/
        def bypass_send_results_gh = bypass_matcher ? true : false

        def pr_number_matcher = output =~ /PR Number: (\d+)/
        def pr_number = pr_number_matcher ? pr_number_matcher[0][1] : null

        if (commit_sha) {
            echo "Commit SHA: ${commit_sha}"
        } else {
            error("Commit SHA not found in output.")
        }
        if (run_number) {
            echo "Workflow Run Number: ${run_number}"
        } else {
            error("Workflow run number not found in output.")
        }
        if (pr_number) {
            echo "PR Number: ${pr_number}"
            echo "This is a PR build."
        }
        echo "Bypass sending test results to GitHub? ${bypass_send_results_gh}"

        return [commit_sha: commit_sha, run_number: run_number, workflow_id: workflow_id, bypass_results: bypass_send_results_gh, pr_number: pr_number]
}

def send_test_results_to_github(commit_sha, sqa_tests_result, sqa_tests_summary) {
    withCredentials([
    usernamePassword(credentialsId: 'Matter-Extension-GitHub', usernameVariable: 'GITHUB_APP', passwordVariable: 'GITHUB_ACCESS_TOKEN')
    ])
    {
        sh """
            python3 -u jenkins_integration/github/send_results_to_github.py --commit_sha ${commit_sha} --sqa_result ${sqa_tests_result} --sqa_summary "${sqa_tests_summary}" --jenkins_url ${env.BUILD_URL}
        """
    }
}

def execute_sanity_tests(nomadNode, deviceGroup, deviceGroupId, appName, matterType, board, wifi_module, branchName, buildNumber)
{
    def failed_test_results = [failedTests: [], failedCount: 0]
    globalLock(credentialsId: 'hwmux_token_matterci', deviceGroup: deviceGroup) {
        node(nomadNode){
            ws('/home/dockerUser/qaWorkspace/')
            {
                dir('utf_app_matter')
                {
                    def commanderDir = ""
                    sshagent(['svc_gsdk-ssh']) {
                        checkout scm: [$class                            : 'GitSCM',
                                        branches                         : [[name: 'main']],
                                        browser                          : [$class: 'Stash',
                                        repoUrl: 'https://stash.silabs.com/scm/utf/utf_app_matter.git/'],
                                        userRemoteConfigs                : [[credentialsId: 'svc_gsdk-ssh',
                                                        url: 'ssh://git@stash.silabs.com/utf/utf_app_matter.git']]]

                        sh ''' git submodule sync --recursive
                            git submodule update --init --recursive -q '''
                        sh 'git submodule foreach --recursive git fetch --tags'
                        sh ''' git clean -ffdx
                            git submodule foreach --recursive -q git reset --hard -q
                            git submodule foreach --recursive -q git clean -ffdx -q '''

                        dir('commander'){
                            checkout scm: [$class               : 'GitSCM',
                                            branches            : [[name: 'master']],
                                            browser             : [$class: 'Stash', repoUrl: 'https://stash.silabs.com/projects/TOOLCHAIN_INTERNAL/repos/simplicity_commander_linux_x64'],
                                            userRemoteConfigs   : [[credentialsId: 'svc_gsdk-ssh', url: 'ssh://git@stash.silabs.com/toolchain_internal/simplicity_commander_linux_x64.git']]]

                            commanderPath = sh(script: "find " + pwd() + " -name 'commander' -type f -print",returnStdout: true).trim()
                            echo commanderPath
                            sh "${commanderPath} -v"
                            commanderDir = commanderPath - "/commander"
                            echo commanderDir
                        }
                    }
                    secrets = [[path: 'teams/gecko-sdk/app/svc_gsdk', engineVersion: 2,
                                secretValues: [[envVar: 'SL_PASSWORD', vaultKey: 'password'],
                                               [envVar: 'SL_USERNAME', vaultKey: 'username']]]]
                    withVault([vaultSecrets: secrets])
                    {
                        withEnv([
                            // vars required for publish to database
                            'UTF_QUEUE_SERVER_URL=amqps://' + SL_USERNAME + ':' + SL_PASSWORD + '@utf-queue-central.silabs.net:443/%2f',
                            "UTF_PRODUCER_APP_ID=$BUILD_TAG",
                            "RELEASE_NAME=25Q2-GA",
                            "TEST_SUITE=MatterCI", // ?
                            "TEST_SCRIPT_REPO=utf-app-matter",
                            "SDK_URL=N/A",        // ?
                            "STUDIO_URL=N/A",     // ?
                            "BRANCH_NAME=$branchName", // ?
                            "SDK_BUILD_NUM=${buildNumber}",
                            "TESTBED_NAME=${deviceGroup}",
                            "GROUP_ID=${deviceGroupId}",
                            "BUILD_URL=$BUILD_URL",
                            "JENKIN_RUN_NUM=${buildNumber}",
                            "JENKINS_JOB_NAME=$JOB_NAME",
                            "JENKINS_SERVER_NAME=$JENKINS_URL",
                            "JENKINS_TEST_RESULTS_URL=$JOB_URL$BUILD_NUMBER/testReport",
                            // vars required for matter test execution (?)
                            "BOARD_ID=${board}",
                            "MATTER_APP_EXAMPLE=${appName}",
                            'RUN_SUITE=true',
                            "MATTER_TYPE=${matterType}",
                            "BUILD_TOOL=SLC",
                            "WIFI_MODULE=${wifi_module}",
                            "TEST_TYPE=ci",
                            'PUBLISH_RESULTS=true', // unneeded?
                            'RUN_TCM_SETUP=false',  // unneeded?
                            'DEBUG=true',
                            "UTF_COMMANDER_PATH=${commanderPath}",
                            "TCM_SIMPLICITYCOMMANDER=${commanderPath}",
                            "SECMGR_COMMANDER_PATH=${commanderPath}",
                            "CSA_MATTER_VERSION=1.5",
                            "PATH+COMMANDER_PATH=${commanderDir}"
                        ])
                        {
                            def test_log_file = 'test_logs.log'
                            sh 'printenv'
                            sh(script: """
                                echo ${TESTBED_NAME}
                                ${commanderPath} --version
                                ./workspace_setup.sh
                                executor/launch_utf_tests.sh --publish_test_results true --hwmux_token ${HW_MUX_TOKEN} --hwmux_group_id ${GROUP_ID} --harness matter_harness_template.yaml --render_harness_template --executor_type local --pytest_command "pytest --tb=native -m ${matterType} tests/ci/test_matter_ci.py" > ${test_log_file} 2>&1 || true
                            """, returnStdout: true).trim()
                            def output = readFile(test_log_file).trim()
                            echo "Test log file output:\n ${output}"
                            failed_test_results = parse_test_results_failures(output)
                            if (failed_test_results.failedCount > 0) {
                                unstable("Failed Test Results: ${failed_test_results}")
                                unstable("Failed Count: ${failed_test_results.failedCount}")
                                unstable("Failed Tests: ${failed_test_results.failedTests.join(', ')}")
                            }
                        }
                    }
                    sh "cp ./reports/pytest-report.html ./reports/pytest-report-${appName}-${board}.html"
                    archiveArtifacts artifacts: "reports/pytest-report-${appName}-${board}.html"
                    junit: 'reports/junit_report.xml'
                    echo "Download test results here: https://jenkins-cbs-iot-matter.silabs.net/job/Matter_extension_CICD/job/${BRANCH_NAME}/${BUILD_NUMBER}/artifact/reports/pytest-report-${appName}-${board}.html"
                }
            }
        }
    }
    return failed_test_results
}

@NonCPS
def parse_test_results_failures(output) {
    def failedTests = []
    def failedCount = 0
    echo "Parse test results"
    output.toString().eachLine { line ->
        def matcher = line =~ /(FAILED|ERROR)\s+tests\/ci\/test_matter_ci\.py::(test_tc[\w\d_]+)\s+-\s+(.*)/
        if (matcher.find()) {
            def testCase = "${matcher[0][2]} - ${matcher[0][3]}"
            unstable("Failed test: ${testCase}")
            if (matcher[0][2] == "test_tc00_network_commissioning") {
                failedTests = ["${testCase}"]
            } else {
                failedTests << testCase
            }
            failedCount++
        }
    }
    return [failedTests: failedTests, failedCount: failedCount]
}

def trigger_sqa_pipelines(pipeline_type)
{
    if(sqaFunctions.isProductionJenkinsServer())
    {
        def smoke_list = ['smoke-thread', 'smoke-wifi', 'smoke-cmp']
        def regression_list = ['feature-thread', 'feature-wifi', 'regression-thread', 'regression-wifi', 'regression-cmp',
                               'regression-ota-thread', 'regression-ota-wifi', 'regression-ota-cmp', 'regression-metrics',
                               'ext-regression-thread', 'ext-regression-wifi', 'ext-regression-cmp',
                               'ext-smoke-thread', 'ext-smoke-wifi', 'ext-smoke-cmp',
                               'endurance-thread', 'endurance-wifi', 'endurance-cmp']
        def errorOccurred = false
        try{
            sshagent(['svc_gsdk-ssh']) {
                if (!fileExists('sqa-pipelines')) {
                    sh 'git clone ssh://git@stash.silabs.com/wmn_sqa/sqa-pipelines.git'
                }
                if(pipeline_type == "smoke") {
                        smoke_list.each { smoke_type ->
                        dir('sqa-pipelines') {
                            try{
                                sqaFunctions.commitToMatterSqaPipelines(smoke_type, "${env.BRANCH_NAME}", "${env.BUILD_NUMBER}")
                            } catch (e) {
                                unstable("Error when triggering ${smoke_type}: ${e.message}")
                                errorOccurred = true
                            }
                        }
                    }
                } else {
                    regression_list.each { regression_type ->
                        dir('sqa-pipelines') {
                            try{
                                sqaFunctions.commitToMatterSqaPipelines(regression_type, "${env.BRANCH_NAME}", "${env.BUILD_NUMBER}")
                            } catch (e) {
                                unstable("Error when triggering ${regression_type}: ${e.message}")
                                errorOccurred = true
                            }
                        }
                    }
                }
            }
        } catch (e) {
            unstable("Error when triggering SQA pipelines: ${e.message}")
            errorOccurred = true
        }
        if (errorOccurred) {
            currentBuild.result = 'UNSTABLE'
        }
    }
}
/**
 * Take a Jenkins action (closure) such as node(){} and retry it in the event
 * of an exception where we think the node was reclaimed by AWS or otherwise
 * crashed
 */
def actionWithRetry(Closure action)
{
    def retryCount = 0
	def abortStepTime = 2
    timeout(time: 2, unit: 'HOURS')
    {
	    while(retryCount <= 5)
	    {
	        try
	        {
	            timeout(time: abortStepTime, unit: 'HOURS') {
					action.call()
				}
	            return
	        }
			//catch(org.jenkinsci.plugins.workflow.steps.FlowInterruptedException abort){ throw abort } //Throw this error if it is a Jenkins abort
			catch(Throwable ex)
	        {

	            def totalError = "Abort information: " + determineIfAbortOrTimeout(ex) + "\nOriginal errors: " + "\n" + ex.toString() + "\n" + "Full stack trace: " + "\n"+ "\n" + ex.getStackTrace().toString()

	            echo 'action threw exception at ' + java.time.LocalDateTime.now() + "\n" + "\n" + totalError

				//Treat null exceptions as ChannelClosedException, due to issues with hanging exceptions that dont return text with ChannelClosedException
				if(totalError.contains("Full stack trace: null") && !totalError.contains("hudson.AbortException: script returned exit code"))
					totalError += "\nNull exception detected, treating as AWS ChannelClosedException"


	            //if(totalError.contains('script returned exit code 2'))
	            //{
	            //	sendDevopsDebugMessage("SUDS failure detected, freezing worker")
	            //	input "Frozen for devops analysis"
	            //}
				if(totalError.contains('Aborted by'))
					throw ex
	            else if((!totalError.contains('ClosedChannelException')           &&
	                !totalError.contains('ChannelClosedException')                &&
					!totalError.contains('Unexpected termination of the channel') &&
					!totalError.contains('FlowInterruptedException')              &&
	                !totalError.contains('RemovedNodeListener')                   &&
	                !totalError.contains('missing workspace')                     &&
	                !totalError.contains('Unable to create live FilePath')        &&
					!totalError.contains('StringIndexOutOfBoundsException')       &&
	                !totalError.contains('MissingContextVariableException') )     ||
	                retryCount == 5)
	            {
					if(retryCount == 5)
	            	{
	            		echo "Retry count limit reached for AWS issues, throwing exception"
	                	throw ex
	                }
	                else
	                {
	                	//Print uc log if core dump detected. Don't fail if log doesn't exist for some reason
	                	//This did not work as the node has been left at this pointp

                      	//if(totalError.contains("script returned exit code 139"))
	                	//{
	                	//	sh "cat /home/buildengineer/.uc/uc.core.log 2>/dev/null"
	                	//}

	                	echo "No AWS errors found, throwing exception"
	                	throw ex
	                }
	            }

	            echo 'Lost slave connection. Retrying with count ' + retryCount
                sleep 90
	            retryCount++
	        }
	    }
	}
}
return this