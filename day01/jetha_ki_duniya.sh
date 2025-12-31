#!/bin/bash

echo "Enter your name: "
read Username

echo "you entered $Username"





echo "Enter your Username"
read -p "Enter Username: " Username
echo "you entered $Username"
sudo useradd -m $Username
echo "new User added"

 
