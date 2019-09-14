# My customizations
# Optionally add this to the top of your .bashrc
# to reset path before each sourcing
# `source /etc/environment`

# custom path hacks
# add relative paths to load $(pwd)/bin
export ORIG_PATH="$PATH"
export SAFE_PATHS='/home/marlen/iris_os'

relative_path_in_safe_dirs () {
  case ":$SAFE_PATHS:" in
    *":$(pwd):"*)
      export PATH="bin:$PATH"
      # echo 'valid directory, add local bin to path'
      ;; # add relative dir to path
    *)
      export PATH=$ORIG_PATH
      # echo 'not a valid directory, reset path'
      ;; # reset path
  esac
}

cd () {
  builtin cd "$@"
  relative_path_in_safe_dirs
}

pushd () {
  builtin pushd "$@"
  relative_path_in_safe_dirs
}

popd () {
  builtin popd "$@"
  relative_path_in_safe_dirs
}

# Fixes `source ~/.bashrc` wiping the current relative path.
relative_path_in_safe_dirs
