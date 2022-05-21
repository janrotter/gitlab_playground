# gitlab-playground

Easily launch a GitLab environment to play with GitLab CI! 

`gitlab-playground` simplifies launching a GitLab instance with a registered gitlab-runner (docker executor). This should be enough to allow you to try out various gitlab-ci.yml patterns in a local, contained environment.

**Warning**: this project should be used for testing or development purposes only!

## Quickstart

Spin up the docker-compose environment with:
```
$ docker-compose up
```

After both `gitlab` and `runner` containers are launched, perform the initial setup
that will configure GitLab with convenient, **but insecure**, credentials and register a runner:
```
$ ./initial_setup.sh
```

GitLab will be accessible on http://localhost with
admin user `root` and password `password`.
