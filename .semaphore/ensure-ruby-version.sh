# Ensure the correct Ruby version is installed and cached
#
cache_key="${SEMAPHORE_AGENT_MACHINE_OS_IMAGE}-${RUBY_VERSION}"

if cache has_key "${cache_key}"; then
  echo "Ruby ${RUBY_VERSION} found in cache"
  cache restore "${cache_key}"
  sem-version ruby "${RUBY_VERSION}" -f
else
  echo "Installing Ruby $RUBY_VERSION"
  sem-version ruby "${RUBY_VERSION}" -f
  cache store "${cache_key}" "${HOME}/.rbenv/versions/${RUBY_VERSION}"
fi

