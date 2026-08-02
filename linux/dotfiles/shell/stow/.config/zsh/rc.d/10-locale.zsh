# LC_ALL is deliberate: ssh_config forwards LANG and LC_* to every host we
# connect to, and only LC_ALL guarantees the remote can't fall back to a locale
# with a different collation order or decimal separator.
export LANG="en_US.UTF-8"
export LANGUAGE="en_US:en"
export LC_ALL="en_US.UTF-8"
