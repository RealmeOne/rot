var ROT = artifacts.require("./ROT.sol");
var Airdrop = artifacts.require("./Airdrop.sol");

module.exports = function(deployer) {
  deployer.deploy(ROT).then(function() {
    return deployer.deploy(Airdrop, ROT.address);
  });
};
