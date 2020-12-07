const express = require("express");
const router = express.Router();
const contractService = require("../services/contract.service");
var Web3 = require("web3");
const contractName = "CuentaAhorro";
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

router.post("/configureContract", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    //Add variables
    console.log("body", req.body);
    let result = await contract.methods
      .configureContract(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Contract configured successfully. ");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/enableContract", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .enableContract()
      .call()
      .then(function (result) {
        res.status(200).send("Enabled contract successfully.");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/addAhorristaAdmin", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    let result = await contract.methods
      .addAhorristaAdmin(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Balance:" + result);
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/addAhorristaByDeposit", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .addAhorristaByDeposit(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Added saver with success!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/approveSaver", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .approveSaver(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Approved saver!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/askBalancePermission", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .askBalancePermission()
      .call()
      .then(function (result) {
        res.status(200).send("Asked for balance permission!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/giveBalancePermission", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .giveBalancePermission(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Approved permission to see balance!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/removeBalancePermission", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .removeBalancePermission(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Removed balance see permission!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/askForLoan", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .askForLoan(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Asked for loan!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/retireFromFund", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .retireFromFund(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Retired from fund successfully!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/reportSaverDeath", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .reportSaverDeath(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Report saver death!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/revokeDeath", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .revokeDeath()
      .call()
      .then(function (result) {
        res.status(200).send("Revoked death!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/closeDeadSaverAccount", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .closeDeadSaverAccount(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Closed dead saver account!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/makeContribution", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .makeContribution(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Made contribution successfully!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/payDebt", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .payDebt(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Payed debt successfully!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/startGestorPostulation", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .startGestorPostulation()
      .call()
      .then(function (result) {
        res.status(200).send("Started gestor postulation process!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/startGestorVoting", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .startGestorVoting()
      .call()
      .then(function (result) {
        res.status(200).send("Started gestor voting process!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/finishGestorVoting", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .finishGestorVoting()
      .call()
      .then(function (result) {
        res.status(200).send("Finished gestor voting!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/postulateFor", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .postulateFor()
      .call()
      .then(function (result) {
        res.status(200).send("Postulated successfully!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/voteGestor", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .voteGestor(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Voted Gestor!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/voteAuditor", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .voteAuditor(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Voted for auditor!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/startGestorPostulation", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .startGestorPostulation()
      .call()
      .then(function (result) {
        res.status(200).send("Approved saver!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/addSubObjective", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .addSubObjective(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Voted for auditor!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/startVotingPeriod", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .startVotingPeriod()
      .call()
      .then(function (result) {
        res.status(200).send("Voted for auditor!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/voteSubObjective", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .voteSubObjective(req.body)
      .call()
      .then(function (result) {
        res.status(200).send("Voted for auditor!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/addClosingVote", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .addClosingVote()
      .call()
      .then(function (result) {
        res.status(200).send("Voted for auditor!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/closeVotingPeriod", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .closeVotingPeriod()
      .call()
      .then(function (result) {
        res.status(200).send("Voted for auditor!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/executeNextSubObjective", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .executeNextSubObjective()
      .call()
      .then(function (result) {
        res.status(200).send("Voted for auditor!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/voteToCloseContract", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .voteToCloseContract()
      .call()
      .then(function (result) {
        res.status(200).send("Voted for auditor!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.get("/closeContract", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);

    let result = await contract.methods
      .closeContract()
      .call()
      .then(function (result) {
        res.status(200).send("Voted for auditor!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

module.exports = router;
