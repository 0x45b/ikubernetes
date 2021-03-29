#!/bin/bash

sed_command="sed -i.bak "
cidr="$1"

$sed_command "s#10.244.0.0/16#$cidr#g" kube-flannel.yml
