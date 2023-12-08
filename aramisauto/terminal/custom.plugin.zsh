#Docker 
function docker_stop() {
    if [ -n "$(docker ps -aq)" ]; then
        docker stop $(docker ps -aq);
    else
        info_pretty("No running containers: skipping", "INFO");
    fi

    return 0;
}

function docker_rm() {
    if [ -n "$(docker ps -aq)" ]; then
        docker rm $(docker ps -aq);
    else
        info_pretty("No stopped containers: skipping", "INFO");
    fi

    return 0;
}

function docker_rmi() {
    if [ -n "$(docker images -aq)" ]; then
        docker rmi -f $(docker images -aq);
    else
        echo "--- No images left: skipping";
    fi

    return 0;
}

function docker_purge() {
    echo "Purging all docker data";

    echo "-- Purging containers";
    docker_stop;
    docker_rm;

    echo "-- Purging images";
    docker_rmi;

    echo "-- Purging networks";
    docker network prune -f;

    echo "-- Pruning system";
    docker system prune -a -f;

    echo "- Purge finished";
}
    
function info_pretty() {
    tput bold;

    if [ $2 = INFO ]; then
        tput setaf 3;
    elif [ $2 = OK ]; then
        tput setaf 2;
    elif [ $2 = KO ]; then
        tput setaf 1;
    fi;

    len=$(echo -n "$1" | wc -c);
    len=$(($len + 4));
    printf "%${len}s\n" "-" | tr ' ' '-';
    echo "| $1 |";
    printf "%${len}s\n" "-" | tr ' ' '-';
    
    tput sgr0;
}

