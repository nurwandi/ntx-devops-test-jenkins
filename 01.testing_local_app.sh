#!/bin/bash

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

NODE_APP_DIRECTORY="$WORKSPACE/nurwandi-ntx-devops-test"

pwd

cd "$NODE_APP_DIRECTORY" || exit
echo "Now inside the directory: $NODE_APP_DIRECTORY"

sudo apt update -y
sudo apt install -y curl

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Ini memuat nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Memuat nvm bash_completion

if command_exists nvm && command_exists node && command_exists npm; then
    echo "NVM, Node.js, and NPM are already installed. Skipping installation."
    echo "Node.js version: $(node -v)"
    echo "NPM version: $(npm -v)"
else
    echo "Starting Node.js installation..."
    
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    nvm install node
    nvm install 16
    nvm use 16

    echo "Node.js version: $(node -v)"
    echo "NPM version: $(npm -v)"
fi

npm start &
sleep 5

if netstat -tuln | grep ':3000' &> /dev/null; then
  echo "Server is running on port 3000."

  echo "Stopping the server..."
  kill $(lsof -t -i:3000)
else
  echo "Server is not running on port 3000."
fi