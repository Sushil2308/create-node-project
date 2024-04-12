
if [ -z "$1" ]; then
    echo "Usage: $0 <project_name> [directory_path]"
    exit 1
fi

if [ -z "$2" ]; then
    directory_path="./$1"
else
    directory_path="$2/$1"
fi

mkdir -p "$directory_path"
cd "$directory_path"

mkdir src
mkdir src/routes
mkdir src/query
mkdir src/db
mkdir config
mkdir tests

touch src/index.js
touch src/routes/api.js
touch src/query/index.js
touch src/db/connection.js
touch config/index.js
touch .gitignore

echo '{
  "name": "'$1'",
  "version": "1.0.0",
  "description": "My Node.js project",
  "main": "src/index.js",
  "scripts": {
    "start": "nodemon src/index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "mysql": "^2.18.1",
    "express": "^4.17.1"
  },
  "devDependencies": {
    "nodemon": "^2.0.13"
  }
}' > package.json

echo "console.log('Server is running...');

const express = require('express');
const app = express();
const { port } = require('../config');

// Routes
const apiRoutes = require('./routes/api');

// Middleware
app.use(express.json());
app.use('/api', apiRoutes);

// Start server
app.listen(port, () => {
  console.log('Server is running on port', port);
});
" > src/index.js

echo "const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
    res.send('API is running');
});

module.exports = router;" > src/routes/api.js

echo "// Exporting the SQL connection as a module
const mysql = require('mysql');
const { database } = require('../../config');

const connection = mysql.createConnection({
  host: database.host,
  user: database.username,
  password: database.password,
  database: database.database
});

connection.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('Connected to MySQL database');
});

module.exports = connection;
" > src/db/connection.js

echo "// Sample SQL query
const { connection } = require('../db/connection');

const sampleQuery = 'SELECT * FROM users';

module.exports = {
    sampleQuery
};
" > src/query/index.js

echo "module.exports = {
    database: {
        host: 'localhost',
        username: 'root',
        password: 'password',
        database: 'my_database'
    },
    port: 3000
};" > config/index.js

echo "node_modules/" > .gitignore
echo "package-lock.json" >> .gitignore

# Inform user
echo "Project structure for $1 created successfully in directory: $directory_path"

# Install dependencies
npm install

# Inform user
echo "Dependencies installed successfully"

# Run the project using nodemon
npm start
