# age tool

`age` is probably the easiest to use to quickly encrypt something for
sharing. This small write up shows a simple workflow for common use.

Install age tool [here](https://github.com/FiloSottile/age#installation)

We all use SSH keys. We can use them to encrypt/decrypt with `age`. And we can
easily find ones public key from their Github page.

```
curl https://github.com/<username>.keys
```

```
age -r "<public-key-content-from-above>" file-to-encrypt.jpg > encrypted-file.jpg.age
```

```
age -d -i ~/.ssh/<private-key> encrypted-file.jpg.age > file.jpg
```
