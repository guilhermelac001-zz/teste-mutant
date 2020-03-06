const express = require('express')
const app = express()
const port = 80;

app.listen(port);
console.log(`Acesse http://localhost: ${port}`);
app.get('/', (req, res) => {
  const candidato = process.env.CANDIDATO || 'Guilherme';
  res.send(`Bem-vindo ${candidato}!`);
});
