# Timendeploy

This is a very simple service that receives a post commit payload from GitHub.

It is configured by branch and does two things:
- pull the repo on the service machine given by the branch from the commit received by the payload
- execute ```cap {branch} deploy:migrations```


Configuration
===

Just create a ```whitelist.yml``` file in the root of the service with this structure:

```yaml
branch_name: path_to_pull_repo
...
```

For example
```yaml
master: /www/current/
preprod: /www/preprod/current/
acceptance: /www/acceptance/current/
```

Start
===

If you have ```thin``` or ```mongrel``` installed you can start the service via respectively ```rake thin``` and ```rake thin```.

If not, you can simply ```rake start``` and it will use ````webrick```


