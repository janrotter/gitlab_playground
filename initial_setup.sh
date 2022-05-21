#!/usr/bin/env bash

set -e

ROOT_PASSWORD="password" # has to be at least 8 characters
REGISTRATION_TOKEN="reg_token"
DOCKER_NETWORK_NAME="$(basename "$PWD")"

echo "Setting the GitLab root password to '${ROOT_PASSWORD}' and runner \
registration token to '${REGISTRATION_TOKEN}'... (This may take a while...)"

docker-compose exec gitlab gitlab-rails runner "\
  passwd='${ROOT_PASSWORD}'; \
  user=User.find_by_username('root'); \
  user.password=passwd; \
  user.password_confirmation=passwd; \
  user.save!; \
  settings = Gitlab::CurrentSettings.current_application_settings;
  settings.set_runners_registration_token('${REGISTRATION_TOKEN}');
  settings.save!;"
echo "Registering the runner..."

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

