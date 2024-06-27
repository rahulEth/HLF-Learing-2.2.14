removeExplorer() {
  echo "Removing explorer"
  cd explorer
  docker-compose down -v
  cd ..
}

removeExplorer