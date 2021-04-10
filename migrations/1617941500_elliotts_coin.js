const ElliottsCoin = artifacts.require("ElliottsCoin");

module.exports = function(_deployer) {
  _deployer.deploy(ElliottsCoin);
  // Use deployer to state migration tasks.
};
