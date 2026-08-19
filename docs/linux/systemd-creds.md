# A bit more security for app secrets

I had this program I used in personal capacity deployed with systemd. The app
secrets were mentioned in the service configuration file (unit file).

I recently stumbled upon `systemd-creds` and switched to using for a bit of
added security.

On Debian Trixie

Install dependencies

```
sudo apt install \
    libtss2-esys-3.0.2-0t64 \
    libtss2-rc0t64 \
    libtss2-mu-4.0.1-0t64 \
    libtss2-tcti-device0t64
```

Verify TPM capabilty

```
systemd-analyze has-tpm2
```

Prepare credentials directory

```
sudo mkdir -p /etc/credentials/
```

Create encrypted credential file

```
systemd-ask-password -n | sudo systemd-creds encrypt - /etc/credentials/myapp-secret.cred
```

Now you can make the secret available to the app from your service
configuration as follows

`sudo systemctl edit --full myapp.service`

```
[Service]
LoadCredentialEncrypted=myapp-secret:/etc/credentials/myapp-secret.cred

Environment="MY_APP_SECRET_FILE=%d/myapp-secret"
```

The credential will be made available at
`/run/credentials/myapp.service/myapp-secret` which you can conveniently access
through `"%d/myapp-secret`.  If the app can accept
secret via file that would be ideal: you pass the path to the secret file via
the appropriate environment variable or command line option. The example above
demonstartes this scenario.

If the app only accepts screts through env var, you could use a wrapper script
to make the secret available to the app.

Please refer the [documetation](https://systemd.io/CREDENTIALS/) for more.
