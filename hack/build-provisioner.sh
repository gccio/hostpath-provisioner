#!/usr/bin/env bash

#Copyright 2021 The hostpath provisioner Authors.
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
script_dir="$(cd "$(dirname "$0")" && pwd -P)"
source "${script_dir}"/common.sh
setGoInProw $GOLANG_VER
if [ "${GOARCH}" != "amd64" ]; then
  #disable dynamic linking for non amd64 architectures. Don't have a proper cross compiler to make this
  #work. In particular can't find a glibc that can be installed.
  CGO_ENABLED=0 go build -a -o _out/hostpath-provisioner cmd/provisioner/hostpath-provisioner.go
else
  CGO_ENABLED=1 go build -a -tags strictfipsruntime -o _out/hostpath-provisioner cmd/provisioner/hostpath-provisioner.go
fi
