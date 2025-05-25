## Bootstrap Flux on a fresh minikube environment for development
```bash
# Create new branch and push it up
BRANCH_NAME=new-branch
git checkout -b $BRANCH_NAME
git push -u origin $BRANCH_NAME

# Get variables for FluxCD
source .env
export GITHUB_TOKEN

# Bootstrap development cluster on new branch
flux bootstrap github \
    --owner=$GITHUB_USER \
    --repository=homelab \
    --private=false \
    --personal=true \
    --path=clusters/development \
    --branch $(git branch --show-current)
```

## Add all changes and push to origin
```bash
git add -A && git commit -m "Example commit" && git push
```