export LANG=en_US.UTF-8

export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

export PATH=$PATH:$(go env GOPATH)
export GOPATH=$(go env GOPATH)
