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
    const sender = req.body.sender;
    let result = await contract.methods
      .configureContract(req.body.data)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
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
    const sender = req.body.sender;

    let result = await contract.methods
      .enableContract()
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
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
    const sender = req.body.sender;

    let result = await contract.methods
      .addAhorristaAdmin(req.body.data)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Succesfully added a saver");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/addAhorristaByDeposit", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .addAhorristaByDeposit(req.body.data)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Added saver with success!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/approveSaver", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .approveSaver(req.body.addressToApprove, req.body.data)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Approved saver!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/askBalancePermission", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .askBalancePermission()
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Asked for balance permission!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/giveBalancePermission", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .giveBalancePermission(req.body.saverToApprove)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Approved permission to see balance!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/removeBalancePermission", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .removeBalancePermission(req.body.saverToRemove)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Removed balance see permission!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/askForLoan", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .askForLoan(req.body.amount)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Asked for loan!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/retireFromFund", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .retireFromFund(req.body.withoutWithdrawal)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Retired from fund successfully!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/reportSaverDeath", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .reportSaverDeath(req.body.reportedAddress)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Report saver death!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/revokeDeath", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .revokeDeath()
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Revoked death!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/closeDeadSaverAccount", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .closeDeadSaverAccount(req.body.deadAddress)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Closed dead saver account!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/makeContribution", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;
    const receiver = req.body.contractAddress;

    web3.eth.sendTransaction({
      to: receiver,
      from: sender,
      value: web3.utils.toWei(req.body.amount.toString(), "ether"),
    });

    let result = await contract.methods
      .makeContribution(req.body.amount, req.body.payRecharge)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Made contribution successfully!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/payDebt", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;
    const receiver = req.body.contractAddress;

    web3.eth.sendTransaction({
      to: receiver,
      from: sender,
      value: web3.utils.toWei(req.body.amount.toString(), "ether"),
    });

    let result = await contract.methods
      .payDebt(req.body.amount)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Payed debt successfully!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/startGestorPostulation", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .startGestorPostulation()
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Started gestor postulation process!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/startGestorVoting", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .startGestorVoting()
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Started gestor voting process!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/finishGestorVoting", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .finishGestorVoting()
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Finished gestor voting!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/postulateFor", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .postulateFor(req.body.forGestor, req.body.forAudit)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Postulated successfully!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/voteGestor", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .voteGestor(req.body.votedAddress)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Voted Gestor!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/voteAuditor", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .voteAuditor(req.body.votedAddress)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Voted for auditor!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/addSubObjective", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .addSubObjective(req.body.description, req.body.total, req.body.address)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Added sub objective!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/startVotingPeriod", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .startVotingPeriod()
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Started sub objective voting!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/voteSubObjective", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .voteSubObjective(req.body.subObjectiveId)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Voted for subObjective!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/addClosingVote", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .addClosingVote()
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Voted to close sub objective voting!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/closeVotingPeriod", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .closeVotingPeriod()
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Closed sub objective voting period!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/executeNextSubObjective", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .executeNextSubObjective()
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Tried to execute next subObjective");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/voteToCloseContract", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .voteToCloseContract()
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Vote to close contract!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/closeContract", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .closeContract()
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Tried to close contract!");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

module.exports = router;
