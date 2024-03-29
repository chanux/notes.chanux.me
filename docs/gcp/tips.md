# GCP: Tips

## rsync to compute instance

`cat ~/.config/gcloud-compute-ssh`

```
#!/bin/sh
host="$1"
shift
exec gcloud compute ssh "$host" -- "$@"
```

Remember to make the file executable.

`chmod +x ~/.config/gcloud-compute-ssh`

Now you can rsync to your compute as follows

```
rsync -e ~/.config/gcloud-compute-ssh -r ./mydir/ <compute-instance-id>:/path/to/sync/to
```

## Run a command in remote GCE instance

```
gcloud compute ssh <instance-id> -- 'cp /path/to/source /path/to/dest '
```

## Google Source Repository Git Access

Add your keys [here](https://source.cloud.google.com/user/ssh_keys)

And in your `~/.gitconfig` file, add following

```
[credential "https://source.developers.google.com"]
    helper = gcloud.sh
```

For those who installed `google-cloud-sdk` with Homebrew, this should be
`gcloud`. See [this SO answer](https://stackoverflow.com/a/39963874/118872) for
more

## Machine Types

```
f1-micro
g1-small
n1-standard-1
```

## Duplicate images across projects

```
gcloud compute --project=<destination-project-id> images create <destination-image-name> --source-image=<source-image-name> --source-image-project=<source-project-id>
```

## Access images across projects

*Access image that belongs to project A from project B*

1. Get the address of Service Account from project B
2. Go to Project B `IAM & admin > IAM` from menu
3. Click Add button on top left.
4. Paste the SA address as Member
5. Select `Compute Engine > Compute Image User`

```
gcloud projects add-iam-policy-binding [PROJECT_ID] \
    --member serviceAccount:[SERVICE_ACCOUNT_EMAIL] --role roles/compute.imageUser
```

If you learn better from videos, try [this](https://www.youtube.com/watch?v=lV39-BaOtg4)

## Get Internal DNS address of a GCE instance

```
curl "http://metadata.google.internal/computeMetadata/v1/instance/hostname" \
    -H "Metadata-Flavor: Google"
```

## Authenticate with service account

```
gcloud auth activate-service-account --key-file="/path/to/key_file.json"
```

## All about roles

Complete [list](https://cloud.google.com/iam/docs/understanding-roles) of GCP
roles and their permissions.
