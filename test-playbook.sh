#!/usr/bin/env bash
set -e

echo "🐳 Building Ubuntu test container..."
DOCKER_BUILDKIT=0 docker build -t dotfiles-test -f Dockerfile.ubuntu .

echo ""
echo "🚀 Running Ansible playbook in container (dry-run)..."
echo "================================================"

# Run playbook with timing
START_TIME=$(date +%s)

docker run --rm \
  -v "$(pwd):/home/testuser/.dotfiles:ro" \
  dotfiles-test \
  bash -c "cd /home/testuser/.dotfiles && ansible-playbook -i inventory.yml --check --diff main.yml"

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "================================================"
echo "✅ Playbook executed successfully in container"
echo "⏱️  Execution time: ${DURATION} seconds"
echo ""
echo "💡 To test interactively, run:"
echo "   docker run -it --rm -v \$(pwd):/home/testuser/.dotfiles dotfiles-test"
