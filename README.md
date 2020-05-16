# MkDocs - Notes

What's going on here? Full write up on [my blog](https://chanux.me/blog/post/automate-static-site-publishing-on-gcp/).

The final product is [notes.chanux.me](https://notes.chanux.me/)

## Setting up Build Step

```
docker pull squidfunk/mkdocs-material
```

Locally test before commiting to it. Then tag and push

```
docker run --rm -it -v $PWD:/docs squidfunk/mkdocs-material build
```

```
docker tag squidfunk/mkdocs-material gcr.io/<PROJECT_ID>/mkdocs-material
```

```
docker push gcr.io/<PROJECT_ID>/mkdocs-material
```
