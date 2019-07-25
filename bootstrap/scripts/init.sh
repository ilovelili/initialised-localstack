#!/usr/bin/env bash

for i in `find "$(cd /opt/bootstrap/templates; pwd)" -name "*.yml" -o -name "*.yaml"`; do
    echo "applying cloudformation ... | source => $i"    
    awslocal cloudformation create-stack --template-body file://$i --stack-name $(basename $i)
done