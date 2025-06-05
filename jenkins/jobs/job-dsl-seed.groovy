// Job DSL Seed Job Creation Script
// This script creates a seed job that will process our Job DSL scripts

import jenkins.model.Jenkins
import hudson.model.FreeStyleProject
import javaposse.jobdsl.plugin.ExecuteDslScripts
import hudson.tasks.Shell

def jenkins = Jenkins.instance

println "=== Creating Job DSL Seed Job ==="

// Create a seed job if it doesn't exist
def seedJobName = 'job-dsl-seed'
def seedJob = jenkins.getItem(seedJobName)

if (seedJob == null) {
    println "Creating new Job DSL seed job: ${seedJobName}"
    
    seedJob = jenkins.createProject(FreeStyleProject, seedJobName)
    seedJob.setDisplayName('Job DSL Seed Job')
    seedJob.setDescription('Seed job that processes Job DSL scripts to create other jobs')
    
    // Add ExecuteDslScripts build step
    def dslBuilder = new ExecuteDslScripts()
    dslBuilder.setScriptText('''
// Load and execute the SnApp pipeline Job DSL script
def pipelineScript = readFileFromWorkspace('snapp-pipeline.groovy')
evaluate(pipelineScript)
''')
    dslBuilder.setUseScriptText(true)
    dslBuilder.setIgnoreExisting(false)
    dslBuilder.setRemovedJobAction(javaposse.jobdsl.plugin.RemovedJobAction.DELETE)
    
    seedJob.getBuildersList().add(dslBuilder)
    
    // Add shell step to copy the Job DSL script to workspace
    def shellBuilder = new Shell('''
# Copy the Job DSL script to workspace
cp /usr/share/jenkins/ref/jobs-dsl/snapp-pipeline.groovy ${WORKSPACE}/snapp-pipeline.groovy
''')
    seedJob.getBuildersList().add(0, shellBuilder)  // Add as first build step
    
    seedJob.save()
    
    println "Created seed job successfully"
    
    // Trigger the seed job to create our pipeline
    println "Triggering seed job to create pipeline..."
    def build = seedJob.scheduleBuild2(0)
    if (build) {
        println "Seed job build scheduled successfully"
    } else {
        println "Failed to schedule seed job build"
    }
} else {
    println "Seed job already exists: ${seedJobName}"
    
    // Trigger it anyway to ensure pipeline is created
    println "Triggering existing seed job..."
    def build = seedJob.scheduleBuild2(0)
    if (build) {
        println "Seed job build scheduled successfully"
    }
}

println "=== Job DSL Seed Job setup complete ==="
