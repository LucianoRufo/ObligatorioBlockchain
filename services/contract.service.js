const path = require("path");
const fs = require("fs-extra");
const solc = require("solc");

const contractFileName = "CuentaAhorro.sol";

const methods = {
  compile() {
    const contractPath = path.resolve(
      process.cwd(),
      "contracts",
      contractFileName
    );

    const sourceContent = {};
    sourceContent[contractFileName] = {
      content: fs.readFileSync(contractPath, "utf8"),
    };  
    const compilerInput = {
      language: "Solidity",
      sources: sourceContent,
      settings: { outputSelection: { "*": { "*": ["abi", "evm.bytecode"] } } },
    };

    const compliedContract = JSON.parse(
      solc.compile(JSON.stringify(compilerInput), { import: getImports })
    );
    console.log("antes");

    const contractName = contractFileName.replace(".sol", "");
    const contract = compliedContract.contracts[contractFileName][contractName];
    console.log("pasó");

    const abi = contract.abi;
    const abiPath = path.resolve(
      process.cwd(),
      "build",
      contractName + "_abi.json"
    );
    fs.writeFileSync(abiPath, JSON.stringify(abi, null, 2));

    const bytecode = contract.evm;
    const bytecodePath = path.resolve(
      process.cwd(),
      "build",
      contractName + "_bytecode.json"
    );
    fs.writeFileSync(bytecodePath, JSON.stringify(bytecode, null, 2));
    console.log("Build complete");
  },

  async deploy() {
    const bytecodePath = path.resolve(
      process.cwd(),
      "build",
      contractFileName.replace(".sol", "") + "_bytecode.json"
    );
    const abiPath = path.resolve(
      process.cwd(),
      "build",
      contractFileName.replace(".sol", "") + "_abi.json"
    );
    const configPath = path.resolve(process.cwd(), "config.json");

    const bytecode = JSON.parse(fs.readFileSync(bytecodePath, "utf8")).bytecode;
    const abi = JSON.parse(fs.readFileSync(abiPath, "utf8"));

    const accounts = await web3.eth.getAccounts();

    try {
      const result = await new web3.eth.Contract(abi)
        .deploy({
          data: "0x" + bytecode.object,
          //arguments: [accounts[1], accounts[2]]
        })
        .send({
          gas: "3000000",
          from: accounts[0],
          value: 0, // web3.utils.toWei('10', 'ether')
        });

      const config = JSON.parse(fs.readFileSync(configPath, "utf8"));
      config.contractAddress = result.options.address;
      fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
    } catch (error) {
      let _error = error;
    }
  },

  getContract(contractName) {
    const configPath = path.resolve(process.cwd(), "config.json");
    const config = JSON.parse(fs.readFileSync(configPath, "utf8"));
    const abiPath = path.resolve(
      process.cwd(),
      "build",
      "CuentaAhorro" + "_abi.json"
    );
    const abi = JSON.parse(fs.readFileSync(abiPath, "utf8"));

    return new web3.eth.Contract(abi, config.contractAddress);
  },
};

module.exports = { ...methods };

//Agregar más casos de necesitar más herencias.
function getImports(dependency) {
  switch (dependency) {
    case "ContratoConfiguracion.sol":
      return {
        contents: fs.readFileSync(
          path.resolve(process.cwd(), "contracts", "ContratoConfiguracion.sol"),
          "utf8"
        ),
      };
    case "SubObjectiveContract.sol":
      return {
        contents: fs.readFileSync(
          path.resolve(process.cwd(), "contracts", "SubObjectiveContract.sol"),
          "utf8"
        ),
      };
    case "ContratoAhorristaConfig.sol":
      return {
        contents: fs.readFileSync(
          path.resolve(process.cwd(), "contracts", "ContratoAhorristaConfig.sol"),
          "utf8"
        ),
      };
    default:
      return { error: "Error on import" };
  }
}
