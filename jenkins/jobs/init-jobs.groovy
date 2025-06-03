import jenkins.model.*
import javaposse.jobdsl.plugin.*

// Create Job DSL seed job to generate our pipeline jobs
def seedJobName = 'job-dsl-seed'
def jobDslScript = new File('/usr/share/jenkins/ref/jobs/snapp-pipeline.groovy').text

// Create the seed job if it doesn't exist
if (!Jenkins.instance.getItemByFullName(seedJobName)) {
    println "Creating Job DSL seed job..."
    
    def seedJob = Jenkins.instance.createProject(
        hudson.model.FreeStyleProject.class,
        seedJobName
    )
    
    seedJob.description = 'Seed job to create SnApp pipeline jobs using Job DSL'
    
    // Add Job DSL build step
    def jobDslStep = new ExecuteDslScripts()
    jobDslStep.setScriptText(jobDslScript)
    jobDslStep.setRemovedJobAction(RemovedJobAction.DELETE)
    
    seedJob.buildersList.add(jobDslStep)
    
    // Save the job
    seedJob.save()
    
    println "Job DSL seed job created successfully"
    
    // Trigger the seed job to create our pipeline jobs
    println "Triggering seed job to create pipeline jobs..."
    seedJob.scheduleBuild(0, new hudson.model.Cause.UserIdCause())
    
} else {
    println "Job DSL seed job already exists"
}

println "Job initialization completed"
