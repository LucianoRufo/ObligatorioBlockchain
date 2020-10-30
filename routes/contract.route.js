const express = require("express");
const router = express.Router();
const contractService = require("../services/contract.service");
var Web3 = require("web3");

router.get("/compile", function (req, res) {
  try {
    contractService.compile();
    res.status(200).send("Contract compiled");
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/deploy", function (req, res) {
  try {
    contractService.deploy();
    res.status(200).send("Contract deployed");
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/sum", async function (req, res) {
  try {
    const contract = contractService.getContract();

    let result = await contract.methods
      .sum(1, 3)
      .call()
      .then(function (result) {
        res.status(200).send("Result:" + result);
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/getBalance", async function (req, res) {
  try {
    const contract = contractService.getContract();
    let result = await contract.methods
      .getBalance()
      .call()
      .then(function (result) {
        res.status(200).send("Balance:" + result);
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/getOwnerBalance", async function (req, res) {
  try {
    const contract = contractService.getContract();

    let result = await contract.methods
      .getOwnerBalance()
      .call()
      .then(function (result) {
        res
          .status(200)
          .send(
            "OwnerBalance in Wei: " +
              result +
              " ******************** " +
              " OwnerBalance in Eth: " +
              Web3.utils.fromWei(result, "ether")
          );
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});
module.exports = router;
