# MkDocs - Notes

What's going on here? Full write up on [my blog](https://chanux.me/blog/post/automate-static-site-publishing-on-gcp/).

The final product is [notes.chanux.me](https://notes.chanux.me/)

## Setting up Build Step

```
export PROJECT_ID=my-project-1337
export MATERIAL_DOCS_VER=7.3.4


```
docker pull squidfunk/mkdocs-material:${MATERIAL_DOCS_VER?}
```

Locally test before commiting to it. Then tag and push

```
docker run --rm -it -v $PWD:/docs squidfunk/mkdocs-material:${MATERIAL_DOCS_VER?} build
```

```
docker tag squidfunk/mkdocs-material:${MATERIAL_DOCS_VER?} gcr.io/${PROJECT_ID?}/mkdocs-material:${MATERIAL_DOCS_VER?}
```

```
docker push gcr.io/${PROJECT_ID?}/mkdocs-material:${MATERIAL_DOCS_VER?}
```

## Build locally

```
docker run --rm -it -v $PWD:/docs --entrypoint mkdocs squidfunk/mkdocs-material:${MATERIAL_DOCS_VER?} build
```

To just run..
```
docker run --rm -it -p 8000:8000 -v $PWD:/docs squidfunk/mkdocs-material:${MATERIAL_DOCS_VER?}
```
