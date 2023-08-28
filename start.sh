#!/bin/sh

set -ex

npx directus bootstrap
npx directus start
