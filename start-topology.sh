#!/bin/bash

# Copyright [2019-2022] Universidade Federal do Espirito Santo
#                       Instituto Federal do Espirito Santo
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#Here you must add the path according your system operation 
RTR=/<path freertr>/rtr.jar
#Here you must add the path according your system operation 
HWSW=/<path hardware and software files>/


tmux new-session -d -s rare 'java -jar '$RTR' routersc '$HWSW'r1-hw.txt '$HWSW'r1-sw.txt'
tmux split-window -v -t 0 -p 50
tmux send 'java -jar '$RTR' routersc '$HWSW'r2-hw.txt '$HWSW'r2-sw.txt' ENTER;
tmux split-window -h -t 0 -p 50
tmux send 'java -jar '$RTR' routersc '$HWSW'r3-hw.txt '$HWSW'r3-sw.txt' ENTER;
tmux split-window -h -t 2 -p 50
tmux send 'java -jar '$RTR' routersc '$HWSW'r4-hw.txt '$HWSW'r4-sw.txt' ENTER;
tmux split-window -v -t 0 -p 50
tmux send 'java -jar '$RTR' routersc '$HWSW'r5-hw.txt '$HWSW'r5-sw.txt' ENTER;
tmux split-window -v -t 2 -p 50
tmux send 'java -jar '$RTR' routersc '$HWSW'r6-hw.txt '$HWSW'r6-sw.txt' ENTER;
tmux select-layout tiled
tmux a;
