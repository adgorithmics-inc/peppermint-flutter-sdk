echo "Setting up git-hooks"
cat $(pwd)/pre-push.sh > $(pwd)/.git/hooks/pre-push
cat $(pwd)/pre-commit.sh > $(pwd)/.git/hooks/pre-commit