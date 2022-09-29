This is the core of a markdown editor forked from https://github.com/outline/rich-markdown-editor

npm install

npm run dev

publish:
npm run build
wrangler pages publish dist

This editor is also part of datagrove, but you are probably better off debugging it standalone with vite. Future work is to eliminate this. In standalone mode we use websockets to communicate to the flutter app.

https://nodejs.dev/en/learn/update-all-the-nodejs-dependencies-to-their-latest-version/


  "overrides": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "prosemirror-tables": "^1.2.5"
  },

// how do w