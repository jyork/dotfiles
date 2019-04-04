# Function to beuild a release mode line handler and deploy

function build_and_deploy_line_handler()
{
    reporootdir=$(git rev-parse --show-toplevel)
    [[ -n "$reporootdir" ]] || return
    basedir=$(basename $reporootdir)
    if [[ $basedir == "ext" || $basedir == "the_arsenal" ]]; then
        reporootdir=$(dirname $reporootdir)
    fi
    pushd $reporootdir >/dev/null
    
    if [ -z "$1" ]; then
	echo Usage: You must pass a line handler and node
	echo Example: dep_lh bitmex 10.192.2.217
	return
    fi
    local build_target="$1_lh"
    local library="lib${build_target}.so"
    local remote="$2"
    local price_server="ps_$1"
    local script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    echo "build release mode $build_target..."
    if [ -x $script_dir/build.sh ]
    then
	build.sh config=release $build_target
    else
	make -j6 config=release $build_target
    fi

    echo "Copying $library to $remote..."
    scp "./build/x86-64/release/lib/$library" "$remote:/home/$USER"

    echo "Stopping $price_server on $remote..."
    ssh $remote "sudo stop $price_server"

    echo "Copy $library into place on $remote..."
    ssh $remote "sudo cp ~/$library /opt/debesys/$price_server/lib/"

    echo "Move $remote $price_server.log to $price_server.log.old ..."
    ssh $remote "mv -f /var/log/debesys/${price_server}.log /var/log/debesys/${price_server}.log.old"

    echo "Starting $price_server on $remote..."
    ssh $remote "sudo start $price_server"

    popd >/dev/null
}
alias dep_lh=build_and_deploy_line_handler
