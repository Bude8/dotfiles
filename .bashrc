# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes
#
# if [ -n "$force_color_prompt" ]; then
#     if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
# 	# We have color support; assume it's compliant with Ecma-48
# 	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
# 	# a case would tend to support setf rather than setaf.)
# 	color_prompt=yes
#     else
# 	color_prompt=
#     fi
# fi
#
# if [ "$color_prompt" = yes ]; then
#     PS1='✦\W\[\033[00m\]\$ '
# else
#     PS1='✦:\w\$ '
# fi
# unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac
#
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias ls='ls --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

PROMPT_COMMAND='echo -en "\033]0; $(basename $PWD) \a"'

export ASH_HOME=$HOME/ash/ash-2.0.2/bin
export PATH="$ASH_HOME:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
eval "$(starship init bash)"

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Top Containers by Mem/CPU e.g. `ktopcpu | head -10` for top 10 CPU containers
alias ktopcpu='kubectl top pod --containers -A --no-headers | grep -v istio-init | sort -k4 -nr'
alias ktopmem='kubectl top pod --containers -A --no-headers | grep -v istio-init | sort -k5 -nr'

alias badpods="kubectl get  po --all-namespaces -owide | grep -Ev 'Running|Completed'"
alias unreadypods="kubectl get  po --all-namespaces -owide | grep -v Completed | grep -E '0/|1/2|2/3|1/3'"
alias drain='kubectl drain --force --ignore-daemonsets --delete-local-data'
alias getautoscaler='kubectl -n kube-system get cm cluster-autoscaler-status -oyaml'
alias k='kubectl'
alias ka='kubectl apply'
alias kd='kubectl describe'
alias kg='kubectl get'
alias kg='kubectl get'
alias kl='kubectl logs'
alias krew='kubectl krew'
alias krm='kubectl delete'
alias ksys='kubectl --namespace kube-system'
alias swap='kubectl config use-context'

# Common log tailing commands using stern
alias fluxlogs="stern -n flux-system -l name=flux --exclude nvidia --exclude images --exclude warming --exclude err=null --exclude 'notified about unrelated change'"
alias helmlogs="stern -n flux-system -oraw helm"
alias nginxcontrollerlogs='stern -n networking controller --exclude time_iso -c controller'
alias nginxrequestlogs='stern controller -oraw --exclude healthz | grep time_iso | jq -CS'
alias pilotlogs='stern -n istio-system istiod'

# Istio
alias ictl='istioctl'
alias proxy-config='istioctl proxy-config'
alias proxy-status='istioctl proxy-status'

# View istio-proxy logs
function proxylogs {
  stern $@ -c istio-proxy --exclude healthz --exclude kube-probe --exclude Prometheus --exclude InboundPassthroughClusterIpv4 -oraw | grep bytes_ | jq -S
}

# Compare 2 objects of the same type e.g. kdiff pod <pod1> <pod2>
function kdiff {
    colordiff -u <(kubectl get $1 $2 -oyaml) <(kubectl get $1 $3 -oyaml)
}

# Trigger a rolling restart of deployments based on partial grep name match
function restart-deploy {
    kubectl get deploy -oname | grep $1 | xargs kubectl rollout restart
}

# Replace all string matches inside dir e.g. replace "version: 1.0.0" "version: 2.0.0"
function replace {
    grep --exclude-dir=".git;.svn" -rl "$1"| xargs sed -i "s/$1/$2/g"
}

function pretty-csv {
    column -t -s, -n "$@" | less -F -S -X -K
}

function activate-poetry {
    source $(poetry env info --path)/bin/activate
}

# Terraform Speedup + Store Logs
alias tf='terraform'
export TF_CLI_ARGS_plan="-parallelism=100"
export TF_CLI_ARGS_apply="-parallelism=100"
export TF_LOG_PATH="$HOME/.terraform.d/terraform.log"
export TF_LOG="TRACE"
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Git
# `git lg` for compact git log
alias g="git"
alias gst='git status'
alias gs='git switch'
alias ga='git add'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcod='git checkout origin/diff/$(git rev-parse --abbrev-ref HEAD)'
alias gd='git diff'
alias gdn='git diff --no-ext-diff'
alias gp='git push'
alias gr='git restore'
alias gfm='git pull'
alias cdr='cd $(git rev-parse --show-toplevel)'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
__git_complete g _git

# PS1='[\u@\h \W $(kube_ps1)]\$ '
# PS1='\W $(kube_ps1)\$ '
# PS1='\[[\e[1;34m\]\W\[\e[0m\]\]\$ '
# PS1='✦ \[\e[0;m\]\W \$ '
# source ~/kube-ps1/kube-ps1.sh
. <(flux completion bash)
alias ..='cd ..'
alias d='docker'
alias dc='docker-compose'
alias f='flux'
alias fget='flux get'
alias fgk='flux get kustomizations'
alias fgs='flux get sources'
alias fr='flux reconcile'
alias frk='flux reconcile kustomization'
alias ing='ingress'
alias javaswap='sudo update-alternatives --config java'
alias koff='kubeoff'
alias kon='kubeon'
alias kust='kustomize'
alias nvimb='nvim ~/.bashrc'
alias nvimi='nvim ~/.config/nvim/init.vim'
alias sourceb='source ~/.bashrc'
alias showbranches="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias ssh_prod='ssh hlee@ny2-lia-001.prod.tradingscreen.com'
alias ssh_reporting='ssh hlee@ny2-lia-001.uatprod.tradingscreen.com -L 23008:db-reporting-1:3008'
alias ssh_reporting_b='ssh hlee@jumpbox.uat.internal -L 23008:eqty3-reportingdb-b-12.uat.internal:3101'
alias ssh_staging='ssh hlee@ny2-laa-011.dev.tradingscreen.com'
alias ssh_uatdev='ssh hlee@ny2-lia-001.uatdev.tradingscreen.com'
alias ssh_uatprod='ssh hlee@ny2-lia-001.uatprod.tradingscreen.com'
alias svc='service'
alias updaterepos='ls -R --directory --color=never */.git | sed "s/\/.git//" | xargs -I{} bash -c "echo Updating {}; git -C {} pull"'
alias mycommits='ls -R --directory --color=never */.git | sed "s/\/.git//" | xargs -I{} bash -c "echo Log for {}; git --no-pager -C {} lg --author='\''Henry Lee'\'' --since='\''2 weeks ago'\''"'
alias ky='kyverno'
alias yl='yamllint'
alias j='jrnl'
alias jt='jrnl @todo'
alias ji='jrnl @improvements'
alias jte='jrnl @todo --edit'
alias jc='jrnl @completed'
alias jce='jrnl @completed --edit'
alias resetindextomaster='git reset $(git merge-base master $(git branch --show-current))'
#alias javalogs="rainbow -y 'ERROR.*' --red='WARN.*' --green='INFO.*' -m 'DEBUG.*' --config=java-stack-trace"
#alias -g jlogs="| rainbow -y 'ERROR.*' --red='WARN.*' --green='INFO.*' -m 'DEBUG.*' --config=java-stack-trace"
alias javalogs="rainbow -y '(error|ERROR).*' --red='(warn|WARN).*' --green='(info|INFO).*' -m '(debug|DEBUG).*' --config=java-stack-trace"
# alias jlogs="| rainbow -y '(error|ERROR|Error).*' --red='(warn|WARN|Warn).*' --green='(info|INFO|Info).*' -m '(debug|DEBUG|Debug).*' --config=java-stack-trace"
alias validate="kubectl apply --validate=true --dry-run=client --filename"
alias colordiff2="colordiff -yW`tput cols`"
alias gke='gcloud container'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias kb='kustomize build'

jlogs() {
  rainbow -y '(error|ERROR|Error).*' --red='(warn|WARN|Warn).*' --green='(info|INFO|Info).*' -m '(debug|DEBUG|Debug).*' --config=java-stack-trace
}

eval $(ssh-agent)
export EDITOR="nvim"
export VIMRC='$HOME/.config/nvim/init.vim'
source "$HOME/.cargo/env"
source $HOME/.keychain/hlee-sh
source <(kubectl completion bash)
export PATH="$HOME/bin:$HOME/install4j9.0.6/bin:$HOME/apache-maven-3.6.3/bin:$HOME/repos/DevOps/devops-scripts/kubernetes/scripts/:$HOME/repos/DevOps/devops-scripts/migration/helm-migration-scripts/:$HOME/.local/bin:$PATH:$HOME/repos/DevOps/k8s-gitops-dev/scripts/bin"

# Zscaler
[[ -f "/usr/local/share/ca-certificates/extra/ZscalerRootCertificate-2048-SHA256.crt" ]] && export SSL_CERT_FILE="/usr/local/share/ca-certificates/extra/ZscalerRootCertificate-2048-SHA256.crt"

. /usr/bin/z.sh
/usr/bin/keychain --nogui ~/.ssh/id_rsa
complete -F __start_kubectl k
complete -F _complete_alias k

# Compare 2 objects of the same type e.g. kdiff pod <pod1> <pod2>
function kdiff {
  colordiff -u <(kubectl get $1 $2 -oyaml) <(kubectl get $1 $3 -oyaml)
}

# Trigger a rolling restart of deployments based on partial grep name match
function restart-deploy {
     kubectl get deploy -oname | grep $1 | xargs kubectl rollout restart
   }

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/henry/google-cloud-sdk/path.bash.inc' ]; then . '/home/henry/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/henry/google-cloud-sdk/completion.bash.inc' ]; then . '/home/henry/google-cloud-sdk/completion.bash.inc'; fi

function rep-health {
    local pod="$(kubectl get pod -oname | grep $1 | head -1)"
    echo "Health check for $pod"
    kubectl exec -it "$pod" -- curl localhost:8080/rep/v1/health -- | jq  '.[] | select (.status |contains ("CRITICAL", "WARNING"))'
}

function pod-health {
    local pod="$(kubectl get pod -oname | grep $1 | head -1)"
    echo "Health check for $pod"
    kubectl exec -it "$pod" -- curl localhost:8080/rep/v1/health -- | jq  '.'
}

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

function diff-k8s-json {
        local expr='del(.items[].status, .items[].metadata.labels,  .items[].metadata.annotations, .items[].metadata.creationTimestamp, .items[].metadata.uid, .items[].metadata.resourceVersion, .items[].metadata.generation )'
        colordiff -u <(jq $expr $1) <(jq $expr $2)
}
. "$HOME/.cargo/env"

export FZF_DEFAULT_COMMAND='fd --type f --color=never --hidden'
export FZF_DEFAULT_OPTS='--no-height --color=bg+:#343d46,gutter:-1,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"

export FZF_ALT_C_COMMAND='fd --type d . --color=never --hidden'
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
source <(yq shell-completion bash)

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin

export KUBECTL_EXTERNAL_DIFF="$HOME/bin/kdiff.sh"
