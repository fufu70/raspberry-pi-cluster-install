#!/bin/bash

# Starts the ngrok server
nohup ./ngrok tcp 22 &
sleep 30 # Wait for a connection to be made
RESULTS=$(python get-ngrok-tunnel.py)
echo $RESULTS
