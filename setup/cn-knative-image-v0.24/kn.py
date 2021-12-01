#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os

knative_version = "v0.24"


def main():
    f = open("kn-image.txt", "r")
    lines = f.readlines()
    for line in lines:
        line = line.strip()
        items = line.split()
        target_version = "registry.cn-hongkong.aliyuncs.com/spotmax/knative-%s:%s" % (items[0], knative_version)
        docker_pull_cmd = "docker pull %s" % (items[2])
        docker_tag_cmd = "docker tag %s %s" % (items[2], target_version)
        docker_push_cmd = "docker push %s" % target_version
        print("********************")
        print("*%18s*" % items[0])
        print("********************")
        os.system(docker_pull_cmd)
        os.system(docker_tag_cmd)
        os.system(docker_push_cmd)
        patch_cmd = "kubectl -n knative-serving set image deployment/%s %s=%s" % (items[0], items[1], target_version)
        print(patch_cmd)


if __name__ == "__main__":
    main()
