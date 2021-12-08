#!/bin/bash

##默认都安装在spotmax-maxcloud namespace下

##安装es集群
cd es &&  ./install.sh && cd ..

##安装kibana
cd kibana && ./install.sh && cd ..

##安装fluentd
cd fluentd &&  ./install.sh && cd ..


