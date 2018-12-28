# Coding Forest (jivimberg.io)

## Setup instructions

1. Build image with: `docker build -t octopress .`
2. Start container mounting git repo on `/octopress` with: `docker run -ti -v $(pwd):/octopress -p 4000:4000 octopress bash` or `docker run -ti -v $(pwd):/octopress --net=host octopress bash` 
3. Run `bundle install`
4. Happy blogging