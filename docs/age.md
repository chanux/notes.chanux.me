# age tool

`age` is probably the easiest to use to quickly encrypt something for
sharing. This small write up shows a simple workflow for common use.

Install age tool with instructiins [here](https://github.com/FiloSottile/age#installation).

We all use SSH keys. We can use them to encrypt/decrypt with `age`. And we can
easily find ones public key from their Github page.

```
curl https://github.com/<username>.keys
```

Pick key from above and use it to encrypt the file of your choice.

```
age -r "<public-key-content-from-above>" file-to-encrypt.jpg > encrypted-file.jpg.age
```

You can now send out the output, `.age` file and the receiver can decrypt it
with their corresponding private key.

```
age -d -i ~/.ssh/<private-key> encrypted-file.jpg.age > file.jpg
```
