### Initial config

* Replace all `example.com` instances with your domain.
* Edit `common.env` and change your timezone.
* Edit `mediacenter/user.env` and set your `UID`/`GID`.
* Add the following files under `/root/secrets` directory:
    * `aws.env` - Set your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` env variables.
    * `nextcloud-db-passwd` - Set a superuser DB password.
* Create `web` network with: `docker network create web`.
