# Timendeploy

This is a very simple service that receives a post commit payload from GitHub.

It is configured by branch and does two things:
- pull the repo on the service machine given by the branch from the commit received by the payload
- execute ```cap {branch} deploy:migrations```


Configuration
===

Just create a ```whitelist.yml``` file in the root of the service with this structure:

```yaml
branch_name:
  directory: path_to_pull_repo
  stage: cap_staging_to_use
  task: cap_task_to_call 
...
```

The only mandatory info per branch is the ```directory``` value. By default the ```stage``` value is the ```branch_name``` and the ```task``` is "deploy:migrations".


Concrete example:
```yaml
master: 
  directory: /www/current/
  stage: prod
  task: deploy
preprod: 
  directory: /www/preprod/current/
acceptance: 
  directory: /www/acceptance/current/
```

Start
===

If you have ```thin``` or ```mongrel``` installed you can start the service via respectively ```rake thin``` and ```rake thin```.

If not, you can simply ```rake start``` and it will use ````webrick```


