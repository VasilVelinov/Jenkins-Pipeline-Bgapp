# Jenkins-Pipeline-Bgapp

       Setting up pipelines,containers and monitoring machines

To set up the environment just run the command vagrant up
On executing vagrant will set up three machines one with Jenkins, one with Docker and one with Prometheus and Grafana.

What is setup automatically?

On first machine “pipelines”:
    • Jenkins is installed with all needed settings
    • plugins are installed (list of all plugins can be viewed in the jenkins_plugins.txt file)
    • admin account is set up : user doadmin password Password1
    • jenkins user is set up to be used as needed, whit password Password1
    • Installed Node Exporter

On machine “containers”:
Gitea is installed and configured to work with the given setting in the exam task.
Installed Node Exporter.

jenkins user is set up to be used as needed.

On machine “monitoring”:
    • Prometheus is installed and configured.
    • Grafana is installed and ready to use.
    • Both Prometheus and Grafana are in containers.
Note: All files for configuration and installataion of the machine, can be found in the coresponding folders, next to the Vagrantfile.

       Manual steps for running our app.

On pipeline machine. 
We need to establish ssh connection to the containers machine.
Log in in jenkins user: 
su jenkins.
Make a ssh connection to the containers machine.
ssh jenkins@containers.do1.exam
Follow the promts needed. When ssh connection is established we are ready to go.

On the Jenkins UI
Go to  Manage Credentials → System → Global Credentials
Add new credentials with the following information:
    • Make sure the User name with password option is selected.
    • Username : vagrant
    • Password: vagrant
    • Description: Local user with password
Add one more for Docker Hub.

First we need to take the token from Docker hub.
Go to hub.docker.com, enter your profile settings, security and generate new token. Save it somewhere. Get back to Jenkins UI.

Go to Manage Jenkins → Configure System
In the SSH remote hosts section Add new entry, whit the following values:
    • Hostname: containers.do1.exam
    • Port: 22
    • Credentials: vagrant(Local user with password)
                   Now the Slave Host need to be set up. 
Go to Manage Jenkins -> Manage Nodes and Clouds
Ad a New Node with name „docker-node“ and select Permanent Agent and click Create
Next set a description of your choice. Set the # of executors to 4. For remote root directory use 
/home/jenkins. Enter Labels docker-node. For usage set Only build jobs with label expression matichng this node. Set Launch method to Launch agents via SSH and for Host enter containers.do1.exam. For credentials select vagrant(Local user with password) Click Save.
                Next is to setup Gitea. 
                   Go to to http://192.168.56.202:3000.
Gitea is already installed and ready to use, thanks to previous step vagrnat up.
What is needed is to make an acount for example user admin , password admin. 
Next go to + icon and click New Migration. 
Follow the instruction. Use https://github.com/shekeriev/fun-facts.git repo provided in the exam task file to migrate the needed files for the app.

               Next step is to set Webhooks

Go to Settings and switch to Webhooks
Enter  http://192.168.99.201:8080/gitea-webhook/post in the Target URL
Scroll down and click the Test Delivery button. The test should be succsesfull.

Nex step is to set the pipeline for the app.
Create a new pipeline with name of choice. Lets use exam-pipeline. 
Chose the GitHub project option and paste the link to you gitea repo.
Slecect GitHub hook trigger for GITScm polling
Select Poll SCM
In the section Pipeline Copy the code located in the jenkins folder file name Jenkinsfile.
Mind the file is bigger than shown on the picture.
Click Save and than Build Now. 
Test build before actual Deploy:
After the pipeline is built, our app can be seen on 192.168.56.202:80

After we change something in our repo the pipeline will rebiuld it self. 

           Settin up Monitoring with Grafana and Prometheus
As mentioned in the beginning of the document, both tools are installed during vagrant up command.
In Grafana the following dashboards are CPU_Load and RAM_utilization.

