#!/bin/bash
git add .
git commit -a -m 'update'
git push
bundle exec ejekyll --pygments
cd _site
rm Gem*
rm git.sh
git init
git add .
git commit -m 'update'
git remote add origin git@github.com:terro/terro.github.com.git
git push -f
