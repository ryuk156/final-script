# Module Generation Automation

The automation focuses on automating the [ModuleSite](https://github.com/MovingBlocks/ModuleSite) for gathering information about modules from [Terasology Organization](https://github.com/Terasology) and 
exhibit their generated information on ModuleSite.This uses an automation tool called [Jenkins](https://www.jenkins.io/), which provides stages and steps in the 
Jenkins pipeline to perform different operations

## File Structure
```
├── Jenkinsfile           - Jenkins pipeline text file
├── loadRepository.sh     - File to collect repository from Terasology Organization
├── scrape.sh             - File to scrape and sort modules and other Non modules repository
├── frontMatter.sh        - File to generate frontmatter form scraped modules 
├── loadModules.sh        - File to clone and copy modules to ModuleSite
```
## Jenkins Job 
This will be a [Pipeline](https://www.jenkins.io/doc/book/pipeline/) job that will run periodically so that if there will be any changes in module information present in the Terasology Organization that information can be updated on ModuleSite easily. 
A pipeline job includes a Jenkinsfile which consist of several stages which define a conceptually distinct subset of tasks performed through the entire Pipeline 
which is used to visualize the pipeline status and stage include a step that performs several operations

## Jenkinsfile
#### Gather data
Gather data stage executes the “loadRepository.sh” which is a shell script to collect all the repository present in the Terasology organization by creating an API call to Github to clone all the repository in the Jenkins Workspace, 
now we will iterate through all the repository present on the Jenkins workspace and load “scrape.sh” shell script to check whether it contains “module.txt ” file or not. 
If it contains “module.txt” then it is a module and we collect require information from that module and store it into a separate directory which we called “meta-data”. 
The meta-data directory  will contain all the modules present in the Terasology organization

#### Frontmatter generation
The frontmatter generation stage executes a “frontmatter. sh” which is a shell script to generated frontmatter from the modules we collected in the meta-data directory. 
The frontmatter includes Post type, Name, cover image, Tags. The post type is to identify whether it is a module or a blog on ModuleSite and the Name will be the name of the module and Tags for searching and filtering modules. 
After the frontmatter is generated  it will be stored on a directory called “modules” which will be present on the Jenkins workspace

#### Commit data to ModuleSite and clean workspace
This stage executes the “loadmodules.sh” shell script which clone’s the ModuleSite repository on Jenkins workspace and removes the existing modules folder from the ModuleSite and copies the modules folder which is on the workspace containing all the modules,
now we will check out to a new branch and check is there any change in the modules using “git status” if yes then changes will be committed and push to the branch we created and we will create a pull request from that branch to ModuleSite master branch using Github API.If no changes then execute next stage i.e Clean workspace which will clean Jenkins workspace and allow us to perform build next without any “directory or file exists” error
