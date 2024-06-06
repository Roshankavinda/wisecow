#!/usr/bin/env bash

SRVPORT=4499
RSPFILE=response

echo "Starting wisecow.sh script..."

rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
    read line
    echo $line
}

handleRequest() {
    # 1) Process the request
    echo "Handling request..."
    get_api
    mod=$(/usr/games/fortune)

    cat <<EOF > $RSPFILE
HTTP/1.1 200 OK

<pre>$("/usr/games/cowsay" "$mod")</pre>
EOF
}

prerequisites() {
    if ! command -v /usr/games/cowsay >/dev/null 2>&1; then
        echo "cowsay not found. Installing..."
        apt-get update && apt-get install -y cowsay
    fi

    if ! command -v /usr/games/fortune >/dev/null 2>&1; then
        echo "fortune not found. Installing..."
        apt-get update && apt-get install -y fortune
    fi

    echo "Prerequisites installed."
}

main() {
    prerequisites
    echo "Wisdom served on port=$SRVPORT..."

    while [ 1 ]; do
        cat $RSPFILE | nc -lN $SRVPORT | handleRequest
        sleep 0.01
    done
}

main
