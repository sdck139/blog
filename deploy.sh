hexo generate
cp -R public/* .deploy/sdck139.github.io
cd .deploy/sdck139.github.io
git add .
git commit -m “update”
git push origin master
