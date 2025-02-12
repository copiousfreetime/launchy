#
# Ensure that ruby-build is installed so we can have the right ruby version
#
if [ -d "$(rbenv root)/plugins/ruby-build" ]; then
  echo "Updating ruby-build"
  git -C "$(rbenv root)/plugins/ruby-build" pull
else
  echo "Installing ruby-build"
  git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
fi
