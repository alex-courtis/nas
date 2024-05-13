#!/bin/sh

find etc -type f -exec diff {} /{} \;
find usr -type f -exec diff {} /{} \;
