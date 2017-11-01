

if [[ -z $GOENVPATH ]]; then
	echo "GOENVPATH not set"
	return 1
fi


function _goenv-envpath {
	echo "$GOENVPATH/envs/$1"
}


function _goenv-help-string {
	echo "Usage: $0 {create|activate|deactivate|delete} name" >&2
	exit 1
}


function _goenv-create {
	local env_path=$(_goenv-envpath $1)

	if [[ ! -d $env_path ]]; then
		echo "===> Creating go-env $1"
		mkdir -p $env_path
		return 0
	else
		echo "===> Failure to create go-env $1, may already exist."
		return 1
	fi
}


function _goenv-activate {
	local env_path=$(_goenv-envpath $1)

	if [[ -d $env_path ]]; then
		echo "===> Activating go-env $1"
		export GOPATH=$env_path
		export PATH=$env_path/bin:$PATH
		export GOENV_ACTIVATED=$1
		return 0
	else
		echo "===> Failure to activate $1, may not exist."
		return 1
	fi
}


function _goenv-deactivate {
	if [[ -v GOENV_ACTIVATED ]]; then
		echo "===> Deactivation go-env $1"
		export PATH=$(echo $PATH | sed "s|$GOPATH/bin:||g")
		unset GOPATH
		unset GOENV_ACTIVATED
		return 0
	else
		echo "===> Failure to deactivate $1, environment may not be active."
		return 1
	fi
}


function _goenv-delete {
	local env_path=$(_goenv-envpath $1)

	if [[ -d $env_path ]]; then
		echo "===> Delete go-env $1 are you sure [y/n]?"
		read reply
		if [[ $reply == 'y' ]]; then
			echo "===> Deleteing"
			rm -rf $env_path
			return 0
		else
			echo "===> Exiting"
			return 0
		fi
	else
		echo "===> Failure to delete $1, environment may not exist."
		return 1
	fi
}


function go-env {
	local help="Usage: $0 {create|activate|deactivate|delete} name"

	if [[ "$#" -ne 2 ]]; then
		_goenv-help-string
	fi

	case "$1" in
		create)
			_goenv-create $2
			;;
		activate)
			_goenv-activate $2
			;;
		deactivate)
			_goenv-deactivate $2
			;;
		delete)
			_goenv-delete $2
			;;
		*)
			_goenv-help-string
			;;
	esac
}


function _go-env() {

	_arguments -C \
		"-h[Show help information]" \
		"--h[Show help information]" \
		"1:go-env command:(create activate deactivate delete)" \
		"2:go-env environments:($GOENVPATH/envs/*(:t))"
}


compdef _go-env go-env
