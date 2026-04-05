# Simple Node.js test image
FROM node:18-alpine

WORKDIR /app

# Create a simple hello world app
RUN echo 'const express = require("express"); const app = express(); app.get("/", (req, res) => res.send("Hello World!")); app.listen(3000, () => console.log("Server running on port 3000"));' > app.js

RUN npm init -y && npm install express

EXPOSE 3000

CMD ["node", "app.js"]
