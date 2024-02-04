# Ensure that the bundle is installed and cached
#

bundle config set --local deployment true
bundle config set --local path vendor/bundle
gem update --no-doc bundler

gemfile_checksum=$(checksum Gemfile.lock)
cache_key="${SEMAPHORE_AGENT_MACHINE_OS_IMAGE}-${RUBY_VERSION}-${gemfile_checksum}"

if cache has_key "${cache_key}"; then
  echo "Bundle for ${RUBY_VERSION} and Gemfile.lock found in cache"
  cache restore "${cache_key}"
else
  echo "Caching Bundle for ${RUBY_VERSION} and Gemfile.lock"
  bundle install
  cache store "${cache_key}" vendor/bundle
fi
