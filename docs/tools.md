# Tools I Use A Lot

I will write a bit about tools I use as I remember

## Z

Originally [rupa/z](https://github.com/rupa/z) but I have switched to
[zoxide](https://github.com/ajeetdsouza/zoxide)

I have generally bad memory so to cd into a commonly used directory with just
a part of the name I remember is really useful.

## Mise

It took me a while to understand [mise-en-place](https://github.com/jdx/mise)
because I got in thinking it replaces direnv + adds more features (See my note
under direnv. I'll keep it).  I relized it's value when I used it to install
(compile) a newer Python.  I already used Pyenv but I found Mise process at
least a tad bit easier.

The `pipx` backend support is also a huge positive for me as I already used
pipx quite a lot.

## Gitui

A TUI for viewing git can come handy sometimes. I used `tig` originally but had
trouble installing it in a corporate environment. I tried
[gitui](https://github.com/gitui-org/gitui) as a replacement and I really like
it!

## Direnv

[Direnv](https://github.com/direnv/direnv) can load/unload environment
variables depending on your current directory. Combined with other
tools/strategies, direnv can give boring looking 'super powers' that greatly
improves quality of life.

One practical example is working with cloud environments. Especially if you
work with multiple cloud accounts, cloud regions etc. you can strategically use
environment variables to auto-configure the environment when you switch into
the respective directory.

I have also tested out mise-en-place, which in my opinion tries to cover a lot
more ground for better or worse. Hence it has been a bit slow for me to adopt
it. But it may suit your style so take a look.

## Zellij

I use this mainly behind corporate barbed wires. I initially tried it because
it was a tmux like thing which I can take behind the barbed wires. Something
I really like about [zellij](https://github.com/zellij-org/zellij) is how
discoverable it's features are.

## FZF

Fzf is fuzzy finder that is really versatil. You can use it in many places and
hence, for a long time I didn't not understand where and how to use it.

Treats me well for not reading the docs! It has integrations for popular shell
environments that will put
[ctrl+r](https://github.com/junegunn/fzf?tab=readme-ov-file#key-bindings-for-command-line)
on steroids!

Also zoxide picks up fzf and works with it!

## Ripgrep (rg)

A very fast Grep with nice default behaviour including filters.

See why you may want to try [ripgrep](https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#why-should-i-use-ripgrep)

## za

My own shell script to go back up the path.

Find za [here](https://gist.github.com/chanux/1119556). For Fish shell, za.fish
is [here](https://gist.github.com/chanux/9411092)

Another idea I have explored is going up to directory by name. bash/zsh/fish
implementations are found
[here](https://gist.github.com/chanux/08c6f53472190a02b33bd49100163d93)

## tenv

I used to use `tfenv` for managing multiple Terraform versions. This is actually
a real use case at work. It helps you testing things with different Terraform
versions. Also, corporate environment sometimes don't let you kill things so
easily so sometimes gotta hang on to some old versions.

Since `tfenv` is not maintained anymore, I switched to
[tenv](https://github.com/tofuutils/tenv). It allows to manage opentofu,
terragrunt, terramate and atmos as well. I can manage multiple Terraform
versions with `mise` as well but have not thought of switching.

## Mailhog

Testing emails from a web app you are building? Start
[here](https://github.com/mailhog/MailHog)

I really liked Mailhog when I did this type of work but it's been a while since
I had test sending e-mail. Mailhog is not maintained anymore and
[Mailpit](https://github.com/axllent/mailpit) seems to want to carry the baton!

There's also [MailCrab](https://github.com/tweedegolf/mailcrab), written in Rust!

## Vegeta

Want to load test your web app? [Vegeta](https://github.com/tsenart/vegeta) is
easy to get started with.
