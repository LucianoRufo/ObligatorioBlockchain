const express = require("express");
const Web3 = require("web3");

var bodyParser = require("body-parser");

//Para usar wallet provider
/*
const HDWalletProvider = require("truffle-hdwallet-provider");
const yourSeedPhrase = "ENTER THE SEED PHRASE HERE";
const yourAccessPoint = "ENTER YOUR ROPSTEN ACCESS POINT HERE";
*/

const port = process.env.port || 3000;
const app = express();

app.use(bodyParser.json());

app.get("/", function (req, res) {
  res.send("Hello world");
});

//Con ganache
const ganacheProvider = new Web3.providers.HttpProvider(
  "http://127.0.0.1:8545"
);
web3 = new Web3(ganacheProvider);

//Con wallet provider
/*
const infuraProvider = new HDWalletProvider(
  yourSeedPhrase,
  yourAccessPoint,
  0,
  3
);*/

const contractRoute = require("./routes/contract.route");
app.use("/api/contract", contractRoute);

app.listen(port, () => console.log("Listening on port 3000"));
