

if [[ -z $GOENVPATH ]]; then
	echo "GOENVPATH not set"
	return 1
fi


function go-env {
	local help="Usage: $0 {create|activate|deactivate|delete} name"
	local env_path=$GOENVPATH/$2

	if [[ "$#" -ne 2 ]]; then
		echo "==> Illegal number of parameters"
		return 1
	fi

	case "$1" in
		create)
			if [[ ! -d $env_path ]]; then
				echo "==> Creating go-env $2"
				mkdir -p $env_path
				return 0
			else
				echo "==> Failure to create go-env $2, may already exist."
				return 1
			fi
			;;
		activate)
			if [[ -d $env_path ]]; then
				echo "==> Activating go-env $2"
				export GOPATH=$env_path
				export PATH=$env_path/bin:$PATH
				export GOENV_ACTIVATED=true
				return 0
			else
				echo "==> Failure to activate $2, may not exist."
				return 1
			fi
			;;
		deactivate)
			if ( $GOENV_ACTIVATED ); then
				echo "==> Deactivating go-env $2"
				export PATH=$(echo $PATH | sed "s|$GOPATH/bin:||g")
				unset GOPATH
				unset GOENV_ACTIVATED
				return 0
			else
				echo "==> Failure to deactivate $2, environment may not be active."
				return 1
			fi
			;;
		delete)
			if [[ -d $env_path ]]; then
				echo "==> Remove go-env $2 are you sure [y/n]?"
				read reply
				if [[ $reply == 'y' ]]; then
					echo "==> Removing go-env $2"
					rm -rf $env_path
					return 0
				else
					echo "==> Exiting"
					return 0
				fi
			else
				echo "==> Failure to delete $2, environment may not exist."
				return 1
			fi
			;;
		*)
			echo $help >&2
			return 1
			;;
	esac
}


function _go-env() {
	local line

	_arguments -C \
		"-h[Show help information]" \
		"--h[Show help information]" \
		"1: :(create activate deactivate delete)"
}


compdef _go-env go-env
