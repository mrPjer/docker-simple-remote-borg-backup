printenv | sed 's/\([^=]*\)=\(.*\)/export \1="\2"/g' > env.sh
