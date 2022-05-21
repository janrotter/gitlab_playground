#!/usr/bin/env bash

set -e

echo "Setting the GitLab root password to 'password'... (This may take a while...)"
docker-compose exec gitlab gitlab-rails runner 'passwd="password"; user=User.find_by_username("root"); user.password=passwd; user.password_confirmation=passwd; user.save!'
echo "Obtaining a runner registration token... (This may also take a while...)"
REGISTRATION_TOKEN=$(docker-compose exec gitlab gitlab-rails runner 'puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token')
echo "Token received!"
echo "Registering the runner..."

DOCKER_NETWORK_NAME="$(basename "$PWD")"

docker-compose exec runner \
  gitlab-runner register \
    --executor docker \
    --non-interactive \
    --registration-token "${REGISTRATION_TOKEN}" \
    --url http://gitlab \
    --clone-url http://gitlab \
    --docker-image alpine \
    --docker-network-mode "${DOCKER_NETWORK_NAME}_default"

echo "Done."

