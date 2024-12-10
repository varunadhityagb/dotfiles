#!/bin/bash

if virsh list --state-running | grep -q "RDPWindows"; then
  echo "The virtual machine RDPWindows is running."
else
  virsh start RDPWindows;
  sleep 10;
fi

windows 

