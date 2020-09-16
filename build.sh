gitbook build ./framework ./_book
cp -R ./_book/* ../ebar-go.github.io/
rm -rf ./_book
