# Deployment

### Create a function

Write function code into it's on folder. Each folder is it's own microservice function.

Folder name is the name of the microservice. It will be used in function deployment everything in the system will depend on that folder name namespace.

Every function should have main.py file with function called main or handler. This acts as the function handler which will be triggered by an HTTP event.

### How to run

Deployment is designed to be completely GitOps so local deployments are discouraged. CircleCi will take care of the deployment process.
