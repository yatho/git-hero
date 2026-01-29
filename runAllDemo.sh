cd examples

# Setup all examples
for dir in */; do
  cd "$dir"
  ./setup.sh
  cd ..
done

# Run demos in sequence
for dir in */; do
  cd "$dir"
  ./demo.sh
  cd ..
done